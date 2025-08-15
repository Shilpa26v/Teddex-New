part of 'pricing_view.dart';

class PricingCubit extends BaseCubit<PricingState> {
  final RazorPayHelper _razorPayHelper = RazorPayHelper();
  StreamSubscription? _subscription;
  bool _isShowAppBar;

  PricingCubit(BuildContext context, PricingState initialState,this._isShowAppBar) : super(context, initialState) {
    Timer.run(_getSubscriptionPlans);
    _subscription = eventBus.listen(_onBusEvent);
  }

  _onBusEvent(BusEvent event) {
    if (event.tag == "currency_updated") {
      _getSubscriptionPlans();
    }
  }

  @override
  Future<void> close() {
    _razorPayHelper.clear();
    _subscription?.cancel();
    return super.close();
  }

  Future<void> purchasePlan(int index) async {
    if (userLoggedIn()) {
      final plan = state.list[index];
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
      var response = await processApi(
        () => apiClient.purchasePlan(planId: plan.id, paymentMethod: paymentMethod!),
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
              title: plan.name + " Pack",
              onSuccess: (paymentId, orderId) async {
                var confirmResp = await processApi(
                  () => apiClient.confirmPlanPayment(orderId: orderId, paymentId: paymentId),
                  doShowLoader: true,
                );
                if (confirmResp != null) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    SuccessView.routeName,
                    ModalRoute.withName(MainView.routeName),
                    arguments: const SuccessArguments(type: "subscription"),
                  );
                }
              },
            );
            break;
          case "paypal":
            var items = state.list
                .map((e) =>
                    {"name": e.name, "quantity": 1, "price": e.price.toStringAsFixed(2), "currency": it.currency})
                .toList();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => UsePaypal(
                  sandboxMode: false,
                  clientId: AppConfig.kPaypalClientId,
                  secretKey: AppConfig.kPaypalSecretKey,
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
                      () => apiClient.confirmPlanPayment(
                        orderId: it.orderId.toString(),
                        paymentId: params["paymentId"].toString(),
                      ),
                      doShowLoader: true,
                    );
                    if (confirmResp != null) {
                      Navigator.of(this.context).pushNamedAndRemoveUntil(
                        SuccessView.routeName,
                        ModalRoute.withName(MainView.routeName),
                        arguments: const SuccessArguments(type: "subscription"),
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

  Future<void> _getSubscriptionPlans() async {
    emit(state.copyWith(isLoading: true));
    var response = await processApi(() => apiClient.getSubscriptionPlans());
    emit(state.copyWith(list: response?.data, isLoading: false));
  }
}
