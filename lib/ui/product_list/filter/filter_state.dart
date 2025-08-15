part of '../product_list_view.dart';

class FilterState extends Equatable {
  final List<Filter> filterData;
  final List<String> selectedFilter;

  const FilterState(
     this.filterData, {
    this.selectedFilter = const [],
  });

  @override
  List<Object?> get props => [ selectedFilter];

  FilterState copyWith({
    List<Filter>? filterData,
    List<String>? selectedFilter,
  }) {
    return FilterState(
      this.filterData,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}
