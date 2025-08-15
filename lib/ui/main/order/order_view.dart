import 'dart:async';
import 'dart:ffi';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/config/app_config.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/main/order/review/review_view.dart';
import 'package:teddex/ui/product_detail/product_detail_view.dart';
import 'package:teddex/widgets/widgets.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

part 'order_cubit.dart';

part 'order_state.dart';

class OrderView extends StatefulWidget {
  const OrderView({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    OrderState state = OrderState(
      StreamController<double>.broadcast(),
    );
    return BlocProvider(
      create: (context) => OrderCubit(context, state),
      child: const OrderView(),
    );
  }

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {

    return NotificationListener<ScrollNotification>(
      onNotification: BlocProvider.of<OrderCubit>(context).onScrollNotification,
      child: Scrollbar(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: BlocProvider.of<OrderCubit>(context).onRefresh,
            ),
            BlocBuilder<OrderCubit, OrderState>(
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
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  sliver: BlocBuilder<OrderCubit, OrderState>(builder: (context, state) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          var initialIndex = index ~/ 2;
                          if (index.isEven) {
                            return _OrderItemView(
                              order: state.list[initialIndex],
                              onPressed: () => BlocProvider.of<OrderCubit>(context).openDetails(initialIndex),
                              onDownload: () => BlocProvider.of<OrderCubit>(context).download(initialIndex, context),
                              onReview: () => BlocProvider.of<OrderCubit>(context).addReview(initialIndex),
                            );
                          } else {
                            return const Divider(indent: 84, endIndent: 16);
                          }
                        },
                        childCount: (state.list.length * 2) - 1,
                        semanticIndexCallback: (child, index) => index ~/ 2,
                      ),
                    );
                  }),
                );
              },
            ),
            BlocBuilder<OrderCubit, OrderState>(
              builder: (context, state) {
                if (state.list.isNotEmpty && state.isLoading) {
                  return const SliverToBoxAdapter(
                    child: CupertinoActivityIndicator(radius: 16,),
                  );
                }
                return const SliverGap(0);
              },
            ),
            const SliverGap(52),
          ],
        ),
      ),
    );
  }
}

class _OrderItemView extends StatelessWidget {
  final Order order;
  final VoidCallback onDownload;
  final VoidCallback onPressed;
  final VoidCallback onReview;

  const _OrderItemView({
    Key? key,
    required this.order,
    required this.onPressed,
    required this.onDownload,
    required this.onReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        color: AppColor.scaffoldBackground,
        child: InkWell(
          highlightColor: AppColor.greyLight.withAlpha(150),
          splashColor: AppColor.greyLight,
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Center(
                    child: SizedBox(
                      width: 86,
                      child: AspectRatio(
                          aspectRatio: 0.9,
                          child: CachedImage(
                            order.image,
                            fit: BoxFit.contain,
                          )),
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText.medium(order.name, size: 15, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const Gap(4),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText.regular(
                                  S.of(context).designCode(order.designId.toString()),
                                  color: AppColor.textPrimaryMedium,
                                  size: 14,
                                ),
                                const Gap(4),
                                CommonText.regular(
                                  S.of(context).date(order.date),
                                  color: AppColor.textPrimaryMedium,
                                  size: 14,
                                ),
                                const Gap(4),
                                CommonText.regular(
                                  S.of(context).orderId(order.orderId.toString()),
                                  color: AppColor.textPrimaryMedium,
                                  size: 14,
                                ),
                                const Gap(4),

                                CommonText.regular(
                                  S.of(context).price(order.price.toString()),
                                  color: AppColor.textPrimaryMedium,
                                  size: 14,
                                ),
                                const Gap(4),
                              ],
                            ),
                          ),
                          ActionIcon(
                            icon: const Icon(Icons.download, color: AppColor.green),
                            tooltip: S.of(context).tooltipDownload,
                            onPressed: onDownload,
                          ),
                          // ActionIcon(
                          //   icon: Icon(
                          //     order.star > 0 ? Icons.star_rounded : Icons.star_border_rounded,
                          //     color: AppColor.yellow,
                          //     size: 32,
                          //   ),
                          //   tooltip: S.of(context).tooltipAddReview,
                          //   onPressed: onReview,
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
