part of 'search_view.dart';

class SearchState extends Equatable {
  final TextEditingController searchController;

  final List<Product> list;
  final bool isLoading;
  final String? vendorId;
  final bool reachAtEnd;

  const SearchState(
    this.searchController, {
    this.list = const [],
    this.isLoading = false,
    this.vendorId ,
    this.reachAtEnd = false,
  });

  @override
  List<Object?> get props => [list, isLoading, reachAtEnd];

  SearchState copyWith({
    List<Product>? list,
    bool? isLoading,
    bool? reachAtEnd,
  }) {
    return SearchState(
      searchController,
      vendorId: vendorId,
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      reachAtEnd: reachAtEnd ?? this.reachAtEnd,
    );
  }
}
