import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:layout/layout.dart' as layout;
import 'package:teddex/base/base.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/product_list/product_list_view.dart';
import 'package:teddex/widgets/widgets.dart';

part 'category_list_cubit.dart';

class CategoryListArguments {
  final Category category;

  const CategoryListArguments({
    required this.category,
  });
}

class CategoryListView extends StatefulWidget {
  const CategoryListView({Key? key}) : super(key: key);

  static const routeName = "/category_list_view";

  static Widget builder(BuildContext context) {
    assert(context.args != null && context.args is CategoryListArguments);
    return BlocProvider(
      create: (ctx) => CategoryListCubit(context, (context.args as CategoryListArguments).category),
      child: const CategoryListView(),
    );
  }

  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  @override
  Widget build(BuildContext context) {
    final initialState = BlocProvider.of<CategoryListCubit>(context).state;
    return Scaffold(
      appBar: AppBar(
        leading: const BackIcon(),
        title: Text(initialState.name),
      ),
      body: Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = initialState.subCategory[index];
                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Card(
                        child: InkWell(
                          highlightColor: AppColor.greyLight.withAlpha(150),
                          splashColor: AppColor.greyLight,
                          onTap: () => BlocProvider.of<CategoryListCubit>(context).onCategorySelected(index),
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            color: AppColor.primary,
                            child: SizedBox(
                              height: 110,
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                      child: CachedImage(
                                    category.mobileHorizontal ?? "",
                                    fit: BoxFit.cover,
                                  )),
                                  Positioned.fill(
                                      child: Container(
                                          color: AppColor.black_40,
                                          alignment: Alignment.center,
                                          child: CommonText.medium(
                                            category.name,
                                            size: 18,
                                            textAlign: TextAlign.center,
                                            color: AppColor.white,
                                          ))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: initialState.subCategory.length,
                ),
              ),
            ),
            SliverGap(context.bottomPadding),
          ],
        ),
      ),
    );
  }
}
