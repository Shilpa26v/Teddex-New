part of 'cart_view.dart';

class CartCubit extends BaseCubit<CartState> {
  final RazorPayHelper _razorPayHelper = RazorPayHelper();

  CartCubit(BuildContext context, CartState initialState) : super(context, initialState) {
    Timer.run(_getCartItems);
  }

  @override
  Future<void> close() {
    _razorPayHelper.clear();
    return super.close();
  }

  void openProductDetail(int index) {
    var item = state.list[index];
    Navigator.of(context).pushNamed(
      ProductDetailView.routeName,
      arguments: ProductDetailArguments(productId: item.productId),
    );
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.maxScrollExtent <= notification.metrics.pixels) {
      onLoadMore();
    }
    return false;
  }

  Future<void> onRefresh() async {
    if (state.isLoading) return;
    emit(state.copyWith(list: []));
    return _getCartItems();
  }

  Future<void> onLoadMore() async {
    if (state.isLoading || state.reachAtEnd) return;
    return _getCartItems();
  }

  Future<void> _getCartItems() async {
    emit(state.copyWith(isLoading: true));
    var response = await processApi(() => apiClient.getCartItems({'start_limit': state.list.length, 'limit': AppConfig.paginationLimit}));
    emit(state.copyWith(
      list: [...state.list, ...response?.data ?? []],
      isLoading: false,
      totalAmount: response?.data.fold<double>(0.0, (previousValue, element) => previousValue + element.price),
      reachAtEnd: response != null && response.data.length < AppConfig.paginationLimit,
    ));
    AppPref.cartCount = response?.data.length ?? AppPref.cartCount;
    eventBus.fire("cart_updated");
  }

  Future<void> removeItem(int index) async {
    var response = await processApi(() => apiClient.deleteCartItem(state.list[index].id));
    response?.let((it) {
      var list = List<Cart>.from(state.list)..removeAt(index);
      emit(state.copyWith(
        list: list,
        totalAmount: list.fold<double>(0.0, (previousValue, element) => previousValue + element.price),
      ));
      AppPref.cartCount = list.length;
      eventBus.fire("cart_updated");
    });
  }

  void checkout() {
    if (userLoggedIn()) {
      var padding = MediaQueryData.fromWindow(WidgetsBinding.instance.window).padding;
      showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(maxHeight: context.height - padding.top - 56),
        isScrollControlled: true,
        builder: (ctx) => BlocProvider.value(
          value: this,
          child: const CheckoutSheet(),
        ),
      );
    }
  }

  void buyMore() {
    Navigator.of(context).popUntil(ModalRoute.withName(MainView.routeName));
  }

  Future<void> createOrder() async {
    Navigator.pop(context);
    var padding = MediaQueryData.fromWindow(WidgetsBinding.instance.window).padding;

    var paymentMethod = AppPref.currencySymbol == "INR"
        ? "razor"
        : await showModalBottomSheet<String>(
            context: context,
            constraints: BoxConstraints(maxHeight: context.height - padding.top - 56),
            isScrollControlled: true,
            builder: (ctx) => MethodOptionSheet(),
          );
    if (paymentMethod.isNullOrEmpty) return;

    var user = AppPref.user!;
    var response = await processApi(
      () => apiClient.createOrder(
        email: user.email ?? "",
        name: user.name ?? "",
        mobile: user.mobile ?? "",
        countryCode: user.countryCode ?? "",
        paymentMethod: paymentMethod!,
      ),
      doShowLoader: true,
    );
    response?.data.let((it) {
      switch (paymentMethod) {
        case "razor":
          _razorPayHelper.checkout(
            key: it.razorKey,
            price: it.amount,
            currency: it.currency,
            orderId: it.razorOrderId,
            title: "Order",
            onSuccess: (paymentId, orderId) async {
              var confirmResp = await processApi(
                () => apiClient.confirmPayment(orderId: orderId, paymentId: paymentId),
                doShowLoader: true,
              );
              if (confirmResp != null) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  SuccessView.routeName,
                  ModalRoute.withName(MainView.routeName),
                  arguments: const SuccessArguments(type: "product"),
                );
              }
            },
          );
          AppPref.cartCount = 0;
          eventBus.fire("cart_updated");
          break;
        case "paypal":
          var items = state.list
              .map((e) => {"name": e.name, "quantity": 1, "price": e.price.toStringAsFixed(2), "currency": it.currency})
              .toList();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => UsePaypal(
                sandboxMode: true,
                clientId: AppConfig.kPaypalClientIdSandBox,
                secretKey: AppConfig.kPaypalSecretKeySandBox,
                returnURL: "https://samplesite.com/return",
                cancelURL: "https://samplesite.com/cancel",
                transactions: [
                  {
                    "amount": {
                      "total": it.amount.toStringAsFixed(2),
                      "currency": it.currency,
                      "details": {
                        "subtotal": it.amount.toStringAsFixed(2),
                        "shipping": '0',
                        "shipping_discount": 0,
                      }
                    },
                    "description": "Order",
                    "payment_options": const {"allowed_payment_method": "INSTANT_FUNDING_SOURCE"},
                    "item_list": {"items": items}
                  }
                ],
                note: "Contact us for any questions on your order.",
                onSuccess: (Map params) async {
                  var confirmResp = await processApi(
                    () => apiClient.confirmPayment(
                      orderId: it.orderId.toString(),
                      paymentId: params["paymentId"].toString(),
                    ),
                    doShowLoader: true,
                  );
                  if (confirmResp != null) {
                    AppPref.cartCount = 0;
                    eventBus.fire("cart_updated");
                    Navigator.of(this.context).pushNamedAndRemoveUntil(
                      SuccessView.routeName,
                      ModalRoute.withName(MainView.routeName),
                      arguments: const SuccessArguments(type: "product"),
                    );
                  }
                },
                onError: (error) {
                  debugPrint("onError: $error");
                },
                onCancel: (params) {
                  debugPrint('cancelled: $params');
                },
              ),
            ),
          );
      }
    });
  }
}
