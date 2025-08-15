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
import 'package:teddex/widgets/widgets.dart';

part 'search_cubit.dart';

part 'search_state.dart';


class SearchListArguments {
  final String? vendorId;

  const SearchListArguments({this.vendorId});
}

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  static const routeName = "/search_view";

  static Widget builder(BuildContext context) {
   // assert(context.args != null && context.args is SearchListArguments);
    return BlocProvider(
      create: (ctx) => SearchCubit(
        context,
        SearchState(TextEditingController(), vendorId:context.args ==null?"": (context.args as SearchListArguments).vendorId),
      ),
      child: const SearchView(),
    );
  }

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    var initialState = BlocProvider.of<SearchCubit>(context).state;
    return Scaffold(
      appBar: AppBar(
        leading: const BackIcon(),
        title: TextFormField(
          controller: initialState.searchController,
          onFieldSubmitted: (_) => BlocProvider.of<SearchCubit>(context).search(),
          decoration: InputDecoration(
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            suffixIcon: Builder(builder: (context) {
              return ActionIcon(
                icon: SquareSvgImageFromAsset(AppImages.imagesSearch, color: IconTheme.of(context).color),
                tooltip: S.of(context).tooltipSearch,
                onPressed: BlocProvider.of<SearchCubit>(context).search,
              );
            }),
            hintText: S.of(context).searchHere,
          ),
        ),
        titleSpacing: 0,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: BlocProvider.of<SearchCubit>(context).onScrollNotification,
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: BlocProvider.of<SearchCubit>(context).onRefresh,
              ),
              BlocBuilder<SearchCubit, SearchState>(
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
                            (context, index) => BlocSelector<SearchCubit, SearchState, Product>(
                          selector: (state) => state.list[index],
                          builder: (context, product) {
                            return ProductItemView(
                              product: product,
                              isLike: product.isFavourite,
                              onLike: (value) => BlocProvider.of<SearchCubit>(context).onLikeChanged(value, index),
                              onPressed: () => BlocProvider.of<SearchCubit>(context).openProductDetail(index),
                            );
                          },
                        ),
                        childCount: state.list.length,
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<SearchCubit, SearchState>(
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

