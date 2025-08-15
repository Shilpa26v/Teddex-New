import 'dart:async';

import 'package:teddex/app/app.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/config/app_config.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/pref/app_pref.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/main/main_view.dart';
import 'package:teddex/ui/payment_method_option_sheet.dart';
import 'package:teddex/ui/product_detail/product_detail_view.dart';
import 'package:teddex/ui/product_list/product_list_view.dart';
import 'package:teddex/ui/success/success_view.dart';
import 'package:teddex/utils/razor_pay_helper.dart';
import 'package:teddex/widgets/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:layout/layout.dart';

part 'cart_cubit.dart';

part 'cart_state.dart';

part 'checkout_sheet.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  static const routeName = "/cart_view";

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(context, const CartState()),
      child: const CartView(),
    );
  }

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackIcon(),
        title: Text(S.of(context).labelMyCart),
      ),
      body:NotificationListener<ScrollNotification>(
    onNotification: BlocProvider.of<CartCubit>(context).onScrollNotification,
    child: Scrollbar(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: BlocProvider.of<CartCubit>(context).onRefresh,
            ),
            BlocBuilder<CartCubit, CartState>(builder: (context, state) {
              if (state.list.isEmpty) {
                if (state.isLoading) {
                  return const SliverFillRemaining(
                    child: CupertinoActivityIndicator(),
                  );
                } else {
                  return SliverFillRemaining(
                    child: EmptyView(label: S.of(context).noCartItems),
                  );
                }
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var initialIndex = index ~/ 2;
                    if (index.isEven) {
                      return _CartItem(
                        onPressed: () => BlocProvider.of<CartCubit>(context).openProductDetail(initialIndex),
                        onRemove: () => BlocProvider.of<CartCubit>(context).removeItem(initialIndex),
                        item: state.list[initialIndex],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  childCount: (state.list.length * 2) - 1,
                  semanticIndexCallback: (child, index) => index ~/ 2,
                ),
              );
            }),
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                if (state.list.isNotEmpty && state.isLoading) {
                  return const SliverToBoxAdapter(
                    child: CupertinoActivityIndicator(),
                  );
                }
                return const SliverGap(0);
              },
            ),
            const SliverGap(16),
          ],
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Scrollable(
            viewportBuilder: (BuildContext context, ViewportOffset position) =>
                BlocBuilder<CartCubit, CartState>(builder: (context, state) {
              final currency = AppCubit.of(context, listen: true).currency;
              return state.list.isNotEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CommonText.medium(
                                S.of(context).totalDesign(state.list.length),
                                size: 14,
                                color: AppColor.textPrimaryMedium,
                              ),
                            ),
                            const Gap(8),
                            Expanded(
                              child: CommonText.medium(
                                S.of(context).totalAmount(currency.currencyText, state.totalAmount.toStringAsFixed(2)),
                                size: 14,
                                color: AppColor.textPrimaryMedium,
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        const Gap(8),
                        Row(
                          children: [
                            Expanded(
                              child: CommonOutlinedButton(
                                onPressed: BlocProvider.of<CartCubit>(context).buyMore,
                                label: S.of(context).btnBuyMore,
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: CommonButton(
                                onPressed: BlocProvider.of<CartCubit>(context).checkout,
                                label: S.of(context).btnCheckout,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : const SizedBox.shrink();
            }),
          ),
        ),
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final Cart item;
  final VoidCallback onRemove;
  final VoidCallback onPressed;

  const _CartItem({
    Key? key,
    required this.item,
    required this.onRemove,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currency = AppCubit.of(context, listen: true).currency;

    return InkWell(
      highlightColor: AppColor.greyLight.withAlpha(150),
      splashColor: AppColor.greyLight,
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      height: 76,
                      child: AspectRatio(
                        aspectRatio: 1.25,
                        child: CachedImage(item.image, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText.medium(item.name, size: 14),
                        const Gap(4),
                        CommonText.regular(S.current.designCode(item.productId), size: 12, color: AppColor.textPrimaryLight),
                        const Gap(8),
                        CommonText.bold(
                          "${currency.currencyText} ${item.price.toString()}",
                          size: 14,
                          color: AppColor.green,
                        ),
                      ],
                    ),
                  ),
                  ActionIcon(
                    icon: const Icon(Icons.delete_forever, color: AppColor.red),
                    onPressed: onRemove,
                    tooltip: S.of(context).tooltipDelete,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
