part of 'product_detail_view.dart';

class ProductDetailCubit extends BaseCubit<ProductDetailState> {
  final int _productId;
  Timer? _timer;
  StreamSubscription? _subscription;

  ProductDetailCubit(
    BuildContext context,
    ProductDetailState initialState,
    this._productId,
  ) : super(context, initialState) {
    Timer.run(_getDetails);
    _subscription = eventBus.listen(_onBusEvent);
    emit(state.copyWith(cartCount: AppPref.cartCount));
  }

  _onBusEvent(BusEvent event) {
    if (event.tag == "cart_updated") {
      emit(state.copyWith(cartCount: AppPref.cartCount));
    }
  }

  void _autoScroll(Timer timer) {
    if (state.imagesController.hasClients) {
      if ((state.imagesController.page?.toInt() ?? 0) >= state.detail!.images.length - 1) {
        state.imagesController.jumpToPage(0);
      } else {
        state.imagesController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
      }
    }
  }

  void addDesignSpecification() {
    var list = <DesignSpecification>[];
    if (state.detail?.id != null) {
      list.add(DesignSpecification(S.current.designCodee, state.detail!.id.toString()));
    }
    if (state.detail?.filters != null && state.detail!.filters!.filters.isNotEmpty) {
      final Specification filter = state.detail!.filters!;

      filter.filters.forEach((key, value) {
        list.add(DesignSpecification(key, value));
      });
    }

    emit(state.copyWith(designSpecificationList: list));
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), _autoScroll);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _subscription?.cancel();
    return super.close();
  }

  Future<void> _getDetails() async {
    emit(state.copyWith(isLoading: true));
    var response = await processApi(() => apiClient.getProductDetail(_productId));
    emit(state.copyWith(detail: response?.data, isLoading: false));
    response?.let((it) => _startTimer());
    addDesignSpecification();
  }

  Future<void> addToCard({bool isBuyNow = true}) async {
    if (userLoggedIn()) {
      var response = await processApi(() => apiClient.addToCart(_productId), doShowLoader: true);
      response?.let((it) => isBuyNow
          ? {
              eventBus.fire("cart_updated"),
              AppPref.cartCount = it.data.length,
              emit(state.copyWith(cartCount: it.data.length)),
              showMessage("Product Added to cart")
            }
          : openCart());
    }
  }

  void buyNow() {
    addToCard(isBuyNow: false);
  }

  Future<void> onImageSelected(int index) async {
    _timer?.cancel();
    await Navigator.of(context).pushNamed(
      ImageSliderView.routeName,
      arguments: ImageSliderViewArgument(
        initialIndex: index,
        listImages: state.detail?.images.map((e) => e.main).toList() ?? [],
      ),
    );
    _startTimer();
  }

  Future<void> onLikeChanged(bool value) async {
    if (userLoggedIn()) {
      var response = await processApi(
        () => value ? apiClient.addToFavourite(_productId) : apiClient.deleteFromFavourite(_productId),
        doShowLoader: true,
      );
      response?.let((it) => emit(state.copyWith(detail: state.detail?.copyWith(isFavourite: value))));
    }
  }

  Future<void> onRelatedProductLikeChanged(bool value, int index) async {
    if (userLoggedIn()) {
      var product = state.detail!.related[index];
      var response = await processApi(
        () => value ? apiClient.addToFavourite(product.id) : apiClient.deleteFromFavourite(product.id),
        doShowLoader: true,
      );
      response?.let((it) {
        var list = List<Product>.from(state.detail!.related);
        list[index] = product.copyWith(isFavourite: value);
        emit(state.copyWith(detail: state.detail?.copyWith(related: list)));
      });
    }
  }

  void openProductDetail(int index) {
    Navigator.of(context).pushNamed(
      ProductDetailView.routeName,
      arguments: ProductDetailArguments(productId: state.detail!.related[index].id),
    );
  }

  void openPricingView() {
    Navigator.of(context).pushNamed(PricingView.routeName, arguments: const PricingArguments(isShowAppBar: true));
  }

  void openCart() {
    if (userLoggedIn()) {
      Navigator.of(context).pushNamed(CartView.routeName);
    }
  }

  void viewAllReviews() {
    Navigator.of(context).pushNamed(
      ReviewListView.routeName,
      arguments: ReviewArguments(listReview: state.detail?.reviews ?? []),
    );
  }

  void navigateToVendorDesign() {
    Navigator.of(context).pushNamed(
      ProductListView.routeName,
      arguments: ProductListArguments(
          cId: state.detail?.categoryId ?? 0,
          categoryName: state.detail?.subCatName ?? "",
          vendorId: state.detail?.vendorId ?? ""),
    );
  }

  Future<void> downloadPdf() async {
    if (userLoggedIn() && state.detail?.pdfFile != null && (state.detail?.pdfFile!.isNotEmpty ?? false)) {
      //downloadFile(context, state.detail!.pdfFile!, _productId.toString());
    }
  }

  Future<void> downloadZip(context) async {
    if (userLoggedIn() && state.detail?.zipName != null && (state.detail?.zipName!.isNotEmpty ?? false)) {
      var isContinue = await showAppDialog<bool>(
        context: context,
        title: S.current.downloadTitle,
        content: S.current.downloadDescription,
        positiveButton: AppDialogButton(
          label: S.current.btnYes,
          onPressed: () => Navigator.of(context).pop(true),
        ),
        negativeButton: AppDialogButton(
          label: S.current.btnNo,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        barrierDismissible: false,
      );
      if (isContinue == true) {
        Log.debug("state.detail??.categoryId..${state.detail?.categoryId}");
        if (state.detail?.categoryId == 379) {
          var response = await processApi(() => apiClient.downloadProduct(state.detail!.id));
          if (response == null) return;
        } else {
          var response = await processApi(() => apiClient.checkForDownload(state.detail!.id));
          if (response == null) return;
        }
        // downloadFile(context, state.detail!.zipName!, _productId.toString());
      }
    }
  }
}
