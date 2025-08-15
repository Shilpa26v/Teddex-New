part of 'favourites_view.dart';

class FavouritesCubit extends BaseCubit<FavouritesState> {
  StreamSubscription? _subscription;

  FavouritesCubit(BuildContext context, FavouritesState initialState) : super(context, initialState) {
    Timer.run(() {
      if (userLoggedIn()) {
        _getProducts();
      }
    });
    _subscription = eventBus.listen(_onBusEvent);
  }

  _onBusEvent(BusEvent event) {
    if (event.tag == "currency_updated") {}
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void openProductDetail(int index) {
    Navigator.of(context).pushNamed(
      ProductDetailView.routeName,
      arguments: ProductDetailArguments(productId: state.list[index].id),
    );
  }

  Future<void> onRefresh() async {
    if (state.isLoading) return;
    emit(state.copyWith(list: []));
    return _getProducts();
  }

  Future<void> _getProducts() async {
    emit(state.copyWith(isLoading: true));
    var response = await processApi(() => apiClient.favouriteProducts( offset: state.list.length));
    emit(state.copyWith(
      list: [...state.list, ...response?.data ?? []],
      isLoading: false,
      reachAtEnd: response != null && response.data.length < AppConfig.paginationLimit,
    ));
  }

  Future<void> onLikeChanged(bool value, int index) async {
    var product = state.list[index];
    var list=state.list;
    list[index]=product.copyWith(isFavourite: !product.isFavourite);
    emit(state.copyWith(list: list));
   // var response = await processApi(() => apiClient.deleteFromFavourite(product.id), doShowLoader: true);
    // response?.let((it) {
    //   var list = List<Product>.from(state.list);
    //   list.removeAt(index);
    //
    // });
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.maxScrollExtent <= notification.metrics.pixels) {
      onLoadMore();
    }
    return false;
  }

  Future<void> onLoadMore() async {
    if (state.isLoading || state.reachAtEnd) return;
    return _getProducts();
  }
}
