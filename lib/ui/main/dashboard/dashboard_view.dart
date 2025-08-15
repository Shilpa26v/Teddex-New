import 'dart:async';

import 'package:teddex/app/app.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/category_list/category_list_view.dart';
import 'package:teddex/ui/product_detail/product_detail_view.dart';
import 'package:teddex/ui/product_list/product_list_view.dart';
import 'package:teddex/widgets/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:layout/layout.dart';

part 'dashboard_cubit.dart';

part 'dashboard_state.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    final state = DashboardState(PageController(viewportFraction: 1));
    return BlocProvider(
      create: (context) => DashboardCubit(context, state),
      child: const DashboardView(),
    );
  }

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> with RouteAware {
  @override
  void didPushNext() {
    BlocProvider.of<DashboardCubit>(context).didPushNext();
    super.didPushNext();
  }

  @override
  void didPopNext() {
    BlocProvider.of<DashboardCubit>(context).didPopNext();
    super.didPopNext();
  }

  @override
  void didChangeDependencies() {
    GetIt.I.get<RouteObserver>().subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    GetIt.I.get<RouteObserver>().unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          return CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: BlocProvider.of<DashboardCubit>(context).onRefresh,
              ),
              if (state.homeBannerList != null && state.homeBannerList!.isNotEmpty)
                SliverToBoxAdapter(
                  child: AspectRatio(
                    aspectRatio: 1.75,
                    child: PageView.builder(
                      controller: state.pageController,
                      itemCount: state.homeBannerList?.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => BlocProvider.of<ProductDetailCubit>(context).onImageSelected(index),
                          child: Hero(
                            tag: "home_banner_$index",
                            child: CachedImage(state.homeBannerList![index].image, fit: BoxFit.fill),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              if (state.homeBannerList != null && state.homeBannerList!.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: AnimatedBuilder(
                        animation: state.pageController,
                        builder: (context, _) {
                          return Hero(
                            tag: "dots_indicator",
                            child: DotsIndicator(
                              itemCount: state.homeBannerList?.length ?? 0,
                              color: AppColor.black,
                              height: 8,
                              width: 8,
                              selectedWidth: 12,
                              gap: 2,
                              selectedIndex: state.pageController.hasClients ? state.pageController.page?.round() ?? 0 : 0,

                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              for (Category category in state.categoryList) ...[
                if (category.subCategory.isNotEmpty) ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    sliver: SliverToBoxAdapter(
                      child: Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        color: AppColor.scaffoldBackground,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 72,
                            child: InkWell(
                              highlightColor: AppColor.greyLight.withAlpha(150),
                              splashColor: AppColor.greyLight,
                              onTap: () => BlocProvider.of<DashboardCubit>(context).onCategorySelected(category),
                              borderRadius: BorderRadius.circular(4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    clipBehavior: Clip.hardEdge,
                                    child: CachedImage(
                                      category.mobileVertical ?? "",
                                      fit: BoxFit.cover,
                                      width: 70,
                                      height: 70,
                                    ),
                                  ),
                                  const Gap(8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CommonText.medium(category.name, size: 16),
                                        if(category.subTitle!=null && category.subTitle!.isNotEmpty)
                                          CommonText.regular(category.subTitle ?? "",
                                              size: 14, color: AppColor.textPrimaryLight, maxLines: 2),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ] else ...[
                  // SliverPadding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  //   sliver: SliverToBoxAdapter(
                  //     child: AspectRatio(
                  //       aspectRatio: 5 / 1,
                  //       child: Card(
                  //         color: context.theme.primaryColor,
                  //         child: InkWell(
                  //           onTap: () => BlocProvider.of<DashboardCubit>(context).onCategorySelected(category),
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Center(
                  //               child: CommonText.semiBold(
                  //                 category.name,
                  //                 size: 20,
                  //                 color: AppColor.white,
                  //                 textAlign: TextAlign.center,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ],

              if (state.dashboard?.homeProductSections != null && state.dashboard!.homeProductSections.isNullOrNotEmpty)
                  for (HomeProductSections homeSection in state.dashboard!.homeProductSections!) ...[
                    if(homeSection.products !=null && homeSection.products!.isNotEmpty)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      sliver: SliverToBoxAdapter(
                        child:CommonText.medium(
                          homeSection.name??"",
                          size: 16,
                        ),
                      ),
                    ),
                    SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        sliver: SliverToBoxAdapter(
                          child: SizedBox(
                            height: 260.0,
                            child: ListView.builder(
                              shrinkWrap: true,
                              clipBehavior: Clip.none,
                              scrollDirection: Axis.horizontal,
                              itemCount: homeSection.products!.length,
                              itemBuilder: (context, index) {
                                var product = homeSection.products![index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                  child: SizedBox(
                                    width: 180,
                                    child: _ProductItemView(
                                      product: product,
                                      onPressed: () => BlocProvider.of<DashboardCubit>(context).openProductDetail(product),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )

                    )

                  ]
              // if (state.dashboard?.trendingProduct != null && (state.dashboard?.trendingProduct!.isNotEmpty ?? false)) ...[
              //   SliverPadding(
              //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //     sliver: SliverToBoxAdapter(
              //       child: Row(
              //         children: [
              //           Expanded(
              //             child: CommonText.medium(
              //               S.of(context).titleLatestEmbroideryDesigns,
              //               size: 16,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              //   SliverPadding(
              //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              //       sliver: SliverToBoxAdapter(
              //         child: SizedBox(
              //           height: 260.0,
              //           child: ListView.builder(
              //             shrinkWrap: true,
              //             clipBehavior: Clip.none,
              //             scrollDirection: Axis.horizontal,
              //             itemCount: state.dashboard!.trendingProduct!.length,
              //             itemBuilder: (context, index) {
              //               var product = state.dashboard!.trendingProduct![index];
              //               return Padding(
              //                 padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              //                 child: SizedBox(
              //                   width: 180,
              //                   child: _ProductItemView(
              //                     product: product,
              //                     onPressed: () => BlocProvider.of<DashboardCubit>(context).openProductDetail(product),
              //                   ),
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //       )
              //
              //   ),
              // ],
              // if (state.dashboard?.mostPopularProduct != null && (state.dashboard?.mostPopularProduct!.isNotEmpty ?? false)) ...[
              //   SliverPadding(
              //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              //     sliver: SliverToBoxAdapter(
              //       child: Row(
              //         children: [
              //           Expanded(
              //             child: CommonText.medium(
              //               S.of(context).titleTrendingDesigns,
              //               size: 16,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              //   SliverPadding(
              //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              //       sliver: SliverToBoxAdapter(
              //         child: SizedBox(
              //           height: 260.0,
              //           child: ListView.builder(
              //             shrinkWrap: true,
              //             clipBehavior: Clip.none,
              //             scrollDirection: Axis.horizontal,
              //             itemCount: state.dashboard!.mostPopularProduct!.length,
              //             itemBuilder: (context, index) {
              //               var product = state.dashboard!.mostPopularProduct![index];
              //               return Padding(
              //                 padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              //                 child: SizedBox(
              //                   width: 180,
              //                   child: _ProductItemView(
              //                     product: product,
              //                     onPressed: () => BlocProvider.of<DashboardCubit>(context).openProductDetail(product),
              //                   ),
              //                 ),
              //               );
              //             },
              //           ),
              //         ),
              //       )
              //
              //     // sliver: SliverGrid(
              //     //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              //     //     maxCrossAxisExtent: 240,
              //     //     crossAxisSpacing: 16,
              //     //     mainAxisSpacing: 16,
              //     //     childAspectRatio: 0.7,
              //     //   ),
              //     //   delegate: SliverChildBuilderDelegate(
              //     //     (context, index) {
              //     //       var product = state.dashboard!.trendingProduct[index];
              //     //       return _ProductItemView(
              //     //         product: product,
              //     //         onPressed: () => BlocProvider.of<DashboardCubit>(context).openProductDetail(product),
              //     //       );
              //     //     },
              //     //     childCount: state.dashboard!.trendingProduct.length > 6 ? 6 : state.dashboard!.trendingProduct.length,
              //     //   ),
              //     // ),
              //   ),
              //   // SliverPadding(
              //   //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //   //   sliver: SliverGrid(
              //   //     gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              //   //       maxCrossAxisExtent: 240,
              //   //       crossAxisSpacing: 16,
              //   //       mainAxisSpacing: 16,
              //   //       childAspectRatio: 0.7,
              //   //     ),
              //   //     delegate: SliverChildBuilderDelegate(
              //   //       (context, index) {
              //   //         var product = state.dashboard!.trendingProduct[index];
              //   //         return _ProductItemView(
              //   //           product: product,
              //   //           onPressed: () => BlocProvider.of<DashboardCubit>(context).openProductDetail(product),
              //   //         );
              //   //       },
              //   //       childCount: state.dashboard!.trendingProduct.length > 6 ? 6 : state.dashboard!.trendingProduct.length,
              //   //     ),
              //   //   ),
              //   // ),
              // ],,
,
              if (state.dashboard?.extraBanner!=null && state.dashboard?.extraBanner!.image != null) ...[
                SliverToBoxAdapter(
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: CachedImage(state.dashboard!.extraBanner!.image, fit: BoxFit.contain),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ProductItemView extends StatelessWidget {
  final Product product;

  final VoidCallback onPressed;

  const _ProductItemView({
    Key? key,
    required this.product,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currency = AppCubit.of(context, listen: true).currency;

    return InkWell(
      highlightColor: AppColor.greyLight.withAlpha(150),
      splashColor: AppColor.greyLight,
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Card(
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all( Radius.circular(8)),),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 0.9,
              child: CachedImage(product.image, fit: BoxFit.contain),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: CommonText.medium(
                        product.name,
                        size: 14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Gap(4),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text.rich(
                          TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              if (product.sellPrice != product.price) ...[
                                TextSpan(
                                  text: currency.currencyText + product.sellPrice.toStringAsFixed(2),
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColor.textPrimaryMedium,
                                  ),
                                ),
                                const WidgetSpan(child: SizedBox(width: 4)),
                              ],
                              TextSpan(
                                text: currency.currencyText + product.price.toStringAsFixed(2),
                                style: const TextStyle(
                                  color: AppColor.green,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              if (product.sellPrice != product.price) ...[
                                const WidgetSpan(child: SizedBox(width: 4)),
                                TextSpan(
                                  text: S
                                      .of(context)
                                      .discount((100 - (product.price * 100 / product.sellPrice)).toStringAsFixed(1)),
                                  style: const TextStyle(
                                    color: AppColor.yellow,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
