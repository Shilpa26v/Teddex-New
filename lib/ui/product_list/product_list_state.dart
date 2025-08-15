part of 'product_list_view.dart';

class ProductListState extends Equatable {
  final int cId;
  final String categoryName;
  final String? venderId;
  final List<Product> list;
  final bool isLoading;
  final bool reachAtEnd;
  final List<Filter> filterData;
  final List<String> selectedFilter;

  const ProductListState(
    this.cId,
    this.categoryName, {
    this.venderId,
    this.list = const [],
    this.isLoading = false,
    this.reachAtEnd = false,
    this.filterData = const [],
    this.selectedFilter = const [],
  });

  @override
  List<Object?> get props => [list, isLoading, reachAtEnd, filterData, selectedFilter];

  ProductListState copyWith({
    List<Product>? list,
    bool? isLoading,
    bool? reachAtEnd,
    List<Filter>? filterData,
    List<String>? selectedFilter,
  }) {
    return ProductListState(
      cId,
      categoryName,
      venderId: venderId,
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      reachAtEnd: reachAtEnd ?? this.reachAtEnd,
      filterData: filterData ?? this.filterData,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
