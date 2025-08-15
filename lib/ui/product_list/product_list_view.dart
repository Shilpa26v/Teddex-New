import 'dart:async';
import 'dart:convert';

import 'package:teddex/network/models/filter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/config/app_config.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/common/product_item_view.dart';
import 'package:teddex/ui/product_detail/product_detail_view.dart';
import 'package:teddex/ui/search/search_view.dart';
import 'package:teddex/widgets/widgets.dart';
import 'package:sliver_tools/sliver_tools.dart';

part 'product_list_cubit.dart';

part 'product_list_state.dart';

part 'filter/filter_view.dart';

part 'filter/filter_cubit.dart';

part 'filter/filter_state.dart';

class ProductListArguments {
  final int cId;
  final String categoryName;
  final String? vendorId;

  const ProductListArguments({required this.cId, required this.categoryName, this.vendorId});
}

class ProductListView extends StatefulWidget {
  const ProductListView({Key? key}) : super(key: key);

  static const routeName = "/product_list_view";

  static Widget builder(BuildContext context) {
    assert(context.args != null && context.args is ProductListArguments);
    return BlocProvider(
      create: (ctx) => ProductListCubit(
        context,
        ProductListState((context.args as ProductListArguments).cId, (context.args as ProductListArguments).categoryName,
            venderId: (context.args as ProductListArguments).vendorId),
      ),
      child: const ProductListView(),
    );
  }

  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  @override
  Widget build(BuildContext context) {
    final initialState = BlocProvider.of<ProductListCubit>(context).state;
    return Scaffold(
      appBar: AppBar(
        leading: const BackIcon(),
        title: Text(initialState.categoryName),
        actions: [
          ActionIcon(
            icon: BlocSelector<ProductListCubit, ProductListState, List<String>>(
              selector: (state) => state.selectedFilter,
              builder: (context, list) {
                return SquareSvgImageFromAsset(AppImages.filter, color: list.isEmpty ? null : AppColor.primary);
              },
            ),
            onPressed: BlocProvider.of<ProductListCubit>(context).openFilterView,
          ),
          ActionIcon(
            icon: SquareSvgImageFromAsset(AppImages.imagesSearch),
            tooltip: S.of(context).tooltipSearch,
            onPressed: BlocProvider.of<ProductListCubit>(context).openSearch,
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: BlocProvider
            .of<ProductListCubit>(context)
            .onScrollNotification,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: BlocProvider
                    .of<ProductListCubit>(context)
                    .onRefresh,
              ),
              BlocBuilder<ProductListCubit, ProductListState>(
                builder: (context, state) {
                  if (state.list.isEmpty) {
                    if (state.isLoading) {
                      return const SliverFillRemaining(
                        child: CupertinoActivityIndicator(),
                      );
                    } else {
                      return SliverFillRemaining(
                        child: EmptyView(label: S.of(context).noProductsFound),
                      );
                    }
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 260,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                            BlocSelector<ProductListCubit, ProductListState, Product>(
                              selector: (state) => state.list[index],
                              builder: (context, product) {
                                return ProductItemView(
                                  product: product,
                                  isLike: product.isFavourite,
                                  onLike: (value) => BlocProvider.of<ProductListCubit>(context).onLikeChanged(value, index),
                                  onPressed: () => BlocProvider.of<ProductListCubit>(context).openProductDetail(index),
                                );
                              },
                            ),
                        childCount: state.list.length,
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<ProductListCubit, ProductListState>(
                builder: (context, state) {
                  if (state.list.isNotEmpty && state.isLoading) {
                    return const SliverToBoxAdapter(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                  return const SliverGap(0);
                },
              ),
              SliverGap(context.bottomPadding),
            ],
          ),
        ),
      ),
    );
  }
}
