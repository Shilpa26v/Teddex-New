part of 'category_view.dart';

class CategoryState extends Equatable {
  final List<Category> list;
  final List<Category> listTrending;
  final bool isLoading;

  const CategoryState({
    this.list = const [],
    this.listTrending = const [],
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [list, isLoading, listTrending];

  CategoryState copyWith({
    List<Category>? list,
    List<Category>? listTrending,
    bool? isLoading,
  }) {
    return CategoryState(
      list: list ?? this.list,
      listTrending: listTrending ?? this.listTrending,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
