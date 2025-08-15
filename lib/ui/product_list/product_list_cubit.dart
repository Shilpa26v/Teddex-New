part of 'product_list_view.dart';

class ProductListCubit extends BaseCubit<ProductListState> {
  ProductListCubit(BuildContext context, ProductListState initialState) : super(context, initialState) {
    Timer.run(_getProducts);
    Timer.run(getFilterData);
  }

  void openProductDetail(int index) {
    Navigator.of(context).pushNamed(
      ProductDetailView.routeName,
      arguments: ProductDetailArguments(productId: state.list[index].id),
    );
  }

  void openSearch() {
    Navigator.of(context).pushNamed(SearchView.routeName,arguments: SearchListArguments(vendorId: state.venderId));
  }

  Future<void> openFilterView() async {
    var result = await Navigator.of(context).pushNamed(
      FilterView.routeName,
      arguments: FilterDataArguments(filterData: state.filterData,selectedFilter: state.selectedFilter),
    );
    if (result != null && result is List<String>) {
      Log.debug("fitter..$result");
      emit(state.copyWith(list: [],selectedFilter: result ));
      _getProducts();
    }
  }

  Future<void> getFilterData() async {
    var response = await processApi(() => apiClient.getFilterData());
    var list = parseCategorizedBooksJson(response?.data);

    emit(state.copyWith(filterData: list));
  }

  List<Filter> parseCategorizedBooksJson(Map<String, dynamic> json) {
    List<Filter> filters = [];
    for (var entry in json.entries) {
      Filter filter = Filter.fromJson(entry);
      filters.add(filter);
    }
    return filters;
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
    return _getProducts();
  }

  Future<void> onLoadMore() async {
    if (state.isLoading || state.reachAtEnd) return;
    return _getProducts();
  }

  Future<void> _getProducts() async {
    emit(state.copyWith(isLoading: true));
    var response = await processApi(() {
      return apiClient.getProducts(
          categoryId: state.cId, vendorId: state.venderId??"",offset: state.list.length, filters: state.selectedFilter.join(','));
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
