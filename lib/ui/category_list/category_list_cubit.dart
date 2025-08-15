part of 'category_list_view.dart';

class CategoryListCubit extends BaseCubit<Category> {
  CategoryListCubit(BuildContext context, Category initialState) : super(context, initialState);

  void onCategorySelected(int index) {
    var category = state.subCategory[index];
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
}
