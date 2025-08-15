part of 'category_view.dart';

class CategoryCubit extends BaseCubit<CategoryState> {
  CategoryCubit(BuildContext context, CategoryState initialState) : super(context, initialState) {
    Timer.run(() {
      _getCategories();
      _getDashboard();
    });
  }

  void onCategorySelected(Category category) {
    if (category.subCategory.isEmpty) {
      Navigator.of(context).pushNamed(
        ProductListView.routeName,
        arguments: ProductListArguments(cId: category.id,categoryName: category.name),
      );
    } else {
      Navigator.of(context).pushNamed(
        CategoryListView.routeName,
        arguments: CategoryListArguments(category: category),
      );
    }
  }

  Future<void> onRefresh() async {
    if (state.isLoading) return;
    emit(state.copyWith(list: []));
    return _getCategories();
  }

  Future<void> _getCategories() async {
    emit(state.copyWith(isLoading: true));
    var response = await processApi(() => apiClient.getCategory());
    emit(state.copyWith(list: response?.data, isLoading: false));
  }

  Future<void> _getDashboard() async {
    var response = await processApi(() => apiClient.getDashboard());
    emit(state.copyWith(listTrending: response?.data.trendingCategory));
  }
}
