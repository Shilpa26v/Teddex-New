import 'dart:async';

import 'package:teddex/helpers/helpers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/category_list/category_list_view.dart';
import 'package:teddex/ui/common/category_item_view.dart';
import 'package:teddex/ui/product_list/product_list_view.dart';
import 'package:teddex/widgets/widgets.dart';

part 'category_cubit.dart';
part 'category_state.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit(context, const CategoryState()),
      child: const CategoryView(),
    );
  }

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        return CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: BlocProvider.of<CategoryCubit>(context).onRefresh,
            ),
            const SliverGap(8),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = state.list[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CategoryItemView(
                      title: category.name,
                      image: category.mobileHorizontal??'',
                      onTap: () => BlocProvider.of<CategoryCubit>(context).onCategorySelected(category),
                    ),
                  );
                },
                childCount: state.list.length,
              ),
            ),
            if (state.listTrending.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: ListTile(
                  title: CommonText.medium(
                    S.of(context).titleTrendingCategories,
                    size: 16,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 240,
                    childAspectRatio: 4.0,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var category = state.listTrending[index];
                      return InkWell(
                        highlightColor: AppColor.greyLight.withAlpha(150),
                        splashColor: AppColor.greyLight,
                        onTap: () => BlocProvider.of<CategoryCubit>(context).onCategorySelected(category),
                        borderRadius: BorderRadius.circular(4),
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                clipBehavior: Clip.hardEdge,
                                child: CachedImage(
                                  category.mobileVertical??"",
                                  fit: BoxFit.cover,
                                  width: 56,
                                  height: 56,
                                ),
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              child: CommonText.medium(category.name, size: 16),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: state.listTrending.length,
                  ),
                ),
              ),
            ],
            const SliverGap(16),
          ],
        );
      },
    );
  }
}
