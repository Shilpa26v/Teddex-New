import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:teddex/pref/app_pref.dart';
import 'package:teddex/ui/main/pricing/pricing_view.dart';
import 'package:teddex/ui/product_list/product_list_view.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:layout/layout.dart';
import 'package:teddex/app/app.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/cart/cart_view.dart';
import 'package:teddex/ui/common/product_item_view.dart';
import 'package:teddex/ui/product_detail/review_list/review_list_view.dart';
import 'package:teddex/widgets/widgets.dart';

import 'image_slider/image_slider_view.dart';

part 'product_detail_cubit.dart';

part 'product_detail_state.dart';

class ProductDetailArguments {
  final int productId;

  const ProductDetailArguments({required this.productId});
}

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({Key? key}) : super(key: key);

  static const routeName = "/product_detail_view";

  static Widget builder(BuildContext context) {
    assert(context.args != null && context.args is ProductDetailArguments);
    return BlocProvider(
      create: (ctx) => ProductDetailCubit(
        context,
        ProductDetailState(PageController()),
        (context.args as ProductDetailArguments).productId,
      ),
      child: const ProductDetailView(),
    );
  }

  @override
  _ProductDetailViewState createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  @override
  Widget build(BuildContext context) {
    final initialState = BlocProvider.of<ProductDetailCubit>(context).state;
    final currency = AppCubit.of(context, listen: true).currency;

    return Scaffold(
      appBar: AppBar(
        leading: const BackIcon(),
        title: BlocBuilder<ProductDetailCubit, ProductDetailState>(builder: (context, state) {
          return Text( S.of(context).appName,);
        }),
        actions: [
          ActionIcon(
            icon: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SquareSvgImageFromAsset(AppImages.imagesCart),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: BlocSelector<ProductDetailCubit, ProductDetailState, int>(
                        selector: (state) => state.cartCount,
                        builder: (context, cartCount) {
                          return Container(
                              height: 16,
                              width: 16,
                              alignment: Alignment.center,
                              decoration:
                                  const BoxDecoration(color: AppColor.red, borderRadius: BorderRadius.all(Radius.circular(8))),
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: FittedBox(
                                  child: Text(
                                    cartCount.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ));
                        }))
              ],
            ),
            tooltip: S.of(context).tooltipCart,
            onPressed: BlocProvider.of<ProductDetailCubit>(context).openCart,
          )
        ],
      ),
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state.detail == null) {
            if (state.isLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              return const EmptyView(label: "");
            }
          }
          final detail = state.detail!;
          return Scrollbar(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: AspectRatio(
                      aspectRatio: 0.9,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          PageView.builder(
                            controller: initialState.imagesController,
                            itemCount: detail.images.length,
                            padEnds: true,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () => BlocProvider.of<ProductDetailCubit>(context).onImageSelected(index),
                              child: Hero(
                                tag: "product_image_$index",
                                child: CachedImage(detail.images[index].main, fit: BoxFit.contain),
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BlocSelector<ProductDetailCubit, ProductDetailState, bool>(
                                selector: (state) => state.detail?.isFavourite ?? false,
                                builder: (context, isLiked) {
                                  return LikeIcon(
                                    value: isLiked,
                                    onChanged: BlocProvider.of<ProductDetailCubit>(context).onLikeChanged,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: AnimatedBuilder(
                        animation: initialState.imagesController,
                        builder: (context, _) {
                          return Hero(
                            tag: "dots_indicator",
                            child: DotsIndicator(
                              itemCount: detail.images.length,
                              color: AppColor.black,
                              height: 8,
                              width: 8,
                              selectedWidth: 16,
                              selectedIndex:
                                  initialState.imagesController.hasClients ? initialState.imagesController.page?.round() ?? 0 : 0,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText.semiBold(detail.name, size: 18),
                        const Gap(4),
                        Row(
                          children: [
                            Expanded(
                              child: Text.rich(
                                TextSpan(
                                  style: const TextStyle(
                                    color: AppColor.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    if (detail.sellPrice != detail.price) ...[
                                      TextSpan(
                                        text: currency.currencyText + detail.sellPrice.toStringAsFixed(2),
                                        style: const TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          color: AppColor.textPrimaryMedium,
                                        ),
                                      ),
                                      const WidgetSpan(child: SizedBox(width: 4)),
                                    ],
                                    TextSpan(
                                      text: currency.currencyText + detail.price.toStringAsFixed(2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (detail.sellPrice != detail.price)
                              CommonText.regular(
                                S.of(context).discount((100 - (detail.price * 100 / detail.sellPrice)).toStringAsFixed(1)),
                                size: 14,
                                color: AppColor.textPrimaryMedium,
                              )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: Divider()),
                if (state.designSpecificationList.isNotEmpty) ...[
                  SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                      sliver: SliverToBoxAdapter(child: CommonText.medium(S.current.designInfo, size: 16))),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                    sliver: SliverToBoxAdapter(
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.designSpecificationList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _DesignSpecificationView(
                                designName: state.designSpecificationList[index].name, value: state.designSpecificationList[index].value, index: index);
                          }),
                    ),
                  ),
                  const SliverToBoxAdapter(child: Divider()),
                ],
                if (detail.details != null && detail.details!.isNotEmpty) ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
                    sliver: SliverToBoxAdapter(
                      child: CommonText.medium(S.current.specification, size: 16),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Html(
                      data: detail.details,
                      style: {
                        "p": Style(
                          color: AppColor.textPrimaryMedium,
                          fontSize: FontSize(14),
                          fontFamily: kFontFamily,
                          padding: HtmlPaddings.all(8),
                        ),
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(child: Divider()),
                ],
                if (detail.vendorId != null && detail.profileShow!=0)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText.medium(S.current.designedBy, size: 16),
                          const Gap(12),
                          Center(
                              child: ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                  borderRadius: BorderRadius.circular(50),
                                  child: CachedImage(detail.profileImage ?? "", width: 100, height: 100))),
                          const Gap(8),
                          Center(child: CommonText.medium(detail.vendorName ?? "", size: 16)),
                          const Gap(10),
                          Center(
                            child: IntrinsicWidth(
                              stepWidth: 32,
                              child: CommonButton(
                                onPressed: () => BlocProvider.of<ProductDetailCubit>(context).navigateToVendorDesign(),
                                label: S.of(context).viewAllDesign,
                              ),
                            ),
                          ),
                          const Gap(8),
                        ],
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: Divider()),
                if (detail.isAbleDownload && detail.pdfFile != null && detail.pdfFile!.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: CommonOutlinedButton(
                        onPressed: BlocProvider.of<ProductDetailCubit>(context).downloadPdf,
                        label: S.of(context).btnDownloadPdf,
                      ),
                    ),
                  ),
                if (detail.reviews.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: ListTile(
                      title: CommonText.medium(S.of(context).titleReviews, size: 16),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var initialIndex = index ~/ 2;
                        if (index.isEven) {
                          var review = detail.reviews[initialIndex];
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CommonText.medium(review.name, size: 14),
                                    ),
                                    const Gap(8),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (index) => Icon(
                                          review.star > index ? Icons.star_rounded : Icons.star_border_rounded,
                                          size: 20,
                                          color: AppColor.yellow,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                CommonText.regular(
                                  review.messages,
                                  color: AppColor.textPrimaryMedium,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const Divider(indent: 16, endIndent: 16);
                        }
                      },
                      childCount: max(0, min(5, detail.reviews.length) * 2 - 1),
                      semanticIndexCallback: (child, index) => index ~/ 2,
                    ),
                  ),
                  if (detail.reviews.length > 5)
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        alignment: AlignmentDirectional.centerEnd,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          onPressed: BlocProvider.of<ProductDetailCubit>(context).viewAllReviews,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(S.of(context).btnViewAllReviews, style: const TextStyle(fontSize: 16)),
                              const Gap(8),
                              const Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
                if (detail.bannerName != null && detail.bannerName!.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: InkWell(
                          onTap: () => BlocProvider.of<ProductDetailCubit>(context).openPricingView(),
                          child: CachedImage(detail.bannerName!, fit: BoxFit.contain)),
                    ),
                  ),
                ],
                if (detail.related.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        ListTile(
                          title: CommonText.medium(S.of(context).labelRelatedProducts, size: 16),
                        ),
                        SizedBox(
                          height: 220,
                          child: ListView.separated(
                            itemCount: detail.related.length,
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) => const Gap(16),
                            itemBuilder: (context, index) => SizedBox(
                              width: 140,
                              child: BlocSelector<ProductDetailCubit, ProductDetailState, Product>(
                                selector: (state) => state.detail!.related[index],
                                builder: (context, product) {
                                  return ProductItemView(
                                    product: product,
                                    isLike: product.isFavourite,
                                    onLike: (value) =>
                                        BlocProvider.of<ProductDetailCubit>(context).onRelatedProductLikeChanged(value, index),
                                    onPressed: () => BlocProvider.of<ProductDetailCubit>(context).openProductDetail(index),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SliverGap(16),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state.isLoading || state.detail == null) return const SizedBox.shrink();
          return BottomAppBar(
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: state.detail?.isAbleDownload == true || state.detail?.price == 0
                    ? CommonButton(
                        onPressed: () => BlocProvider.of<ProductDetailCubit>(context).downloadZip(context),
                        label: S.of(context).btnDownload,
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: CommonOutlinedButton(
                              onPressed: BlocProvider.of<ProductDetailCubit>(context).addToCard,
                              label: S.of(context).btnAddToCart,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CommonButton(
                              onPressed: BlocProvider.of<ProductDetailCubit>(context).buyNow,
                              label: S.of(context).btnBuyNow,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DesignSpecificationView extends StatelessWidget {
  final String designName;
  final String value;
  final int index;

  const _DesignSpecificationView({
    Key? key,
    required this.designName,
    required this.value,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
      color: index % 2 == 0 ? AppColor.greyLight_200 : AppColor.greyMedium,
      child: Row(
        children: [
          Expanded(flex: 3, child: CommonText.regular(designName, size: 16, color: AppColor.textPrimaryMedium)),
          Expanded(flex: 5, child: CommonText.regular(value, size: 16)),
        ],
      ),
    );
  }
}
