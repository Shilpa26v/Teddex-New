part of 'search_view.dart';

class SearchCubit extends BaseCubit<SearchState> {
  SearchCubit(BuildContext context, SearchState initialState) : super(context, initialState);

  String _searchText = "";

  void openProductDetail(int index) {
    Navigator.of(context).pushNamed(
      ProductDetailView.routeName,
      arguments: ProductDetailArguments(productId: state.list[index].id),
    );
  }

  void search() {
    _searchText = state.searchController.text;
    onRefresh();
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
    if (_searchText.isNotEmpty) {
      return _getProducts();
    }
  }

  Future<void> onLoadMore() async {
    if (state.isLoading || state.reachAtEnd) return;
    return _getProducts();
  }

  Future<void> _getProducts() async {
    emit(state.copyWith(isLoading: true));
    var response = await processApi(() {
      return apiClient.searchProducts(search: _searchText, vendorId:state.vendorId??"",offset: state.list.length);
    });
    emit(state.copyWith(
      list: [...state.list, ...response?.data ?? []],
      isLoading: false,
      reachAtEnd: response != null && response.data.length < AppConfig.paginationLimit,
    ));
  }

  Future<void> onLikeChanged(bool value, int index) async {
    if (userLoggedIn()) {
      var product = state.list[index];
      var response = await processApi(
        () => value ? apiClient.addToFavourite(product.id) : apiClient.deleteFromFavourite(product.id),
        doShowLoader: true,
      );
      response?.let((it) {
        var list = List<Product>.from(state.list);
        list[index] = product.copyWith(isFavourite: value);
        emit(state.copyWith(list: list));
      });
    }
  }
}
