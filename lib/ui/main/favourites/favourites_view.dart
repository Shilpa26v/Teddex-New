import 'dart:async';

import 'package:teddex/config/app_config.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/ui/common/product_item_view.dart';
import 'package:teddex/ui/product_detail/product_detail_view.dart';
import 'package:teddex/widgets/widgets.dart';

part 'favourites_cubit.dart';
part 'favourites_state.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => FavouritesCubit(context, const FavouritesState()),
      child: const FavouritesView(),
    );
  }

  @override
  _FavouritesViewState createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: BlocProvider
          .of<FavouritesCubit>(context)
          .onScrollNotification,
      child: Scrollbar(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: BlocProvider.of<FavouritesCubit>(context).onRefresh,
            ),
            BlocBuilder<FavouritesCubit, FavouritesState>(
              builder: (context, state) {
                if (state.list.isEmpty) {
                  if (state.isLoading) {
                    return const SliverFillRemaining(
                      child: CupertinoActivityIndicator(),
                    );
                  } else {
                    return SliverFillRemaining(
                      child: EmptyView(label: S.of(context).noFavouriteProductsFound),
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
                      (context, index) => ProductItemView(
                        product: state.list[index],
                        isLike: true,
                        onLike: (value) => BlocProvider.of<FavouritesCubit>(context).onLikeChanged(value, index),
                        onPressed: () => BlocProvider.of<FavouritesCubit>(context).openProductDetail(index),
                      ),
                      childCount: state.list.length,
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<FavouritesCubit, FavouritesState>(
              builder: (context, state) {
                if (state.list.isNotEmpty && state.isLoading) {
                  return const SliverToBoxAdapter(
                    child: CupertinoActivityIndicator(radius: 16),
                  );
                }
                return const SliverGap(0);
              },
            ),
            SliverGap(context.bottomPadding),
          ],
        ),
      ),
    );
  }
}
