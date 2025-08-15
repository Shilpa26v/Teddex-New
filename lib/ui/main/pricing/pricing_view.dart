import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:layout/layout.dart';
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
import 'package:teddex/ui/success/success_view.dart';
import 'package:teddex/utils/razor_pay_helper.dart';
import 'package:teddex/widgets/widgets.dart';

part 'pricing_cubit.dart';

part 'pricing_state.dart';

class PricingArguments {
  final bool isShowAppBar;

  const PricingArguments({required this.isShowAppBar});
}

class PricingView extends StatefulWidget {
  const PricingView({Key? key}) : super(key: key);

  static const routeName = "/pricing_view";

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (ctx) => PricingCubit(
        context,
        const PricingState(),
        context.args != null ? (context.args as PricingArguments).isShowAppBar : false,
      ),
      child: const PricingView(),
    );
  }

  @override
  _PricingViewState createState() => _PricingViewState();
}

class _PricingViewState extends State<PricingView> {
  @override
  Widget build(BuildContext context) {
    final currency = AppCubit.of(context, listen: true).currency;
    final cubit = BlocProvider.of<PricingCubit>(context);

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: cubit._isShowAppBar
            ? AppBar(
                leading: const BackIcon(),
                title: Text(S.current.pricing),
              )
            : null,
        body: BlocBuilder<PricingCubit, PricingState>(builder: (context, state) {
          if (state.list.isEmpty && state.isLoading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          return ListView.separated(
            itemCount: state.list.length,
            padding: const EdgeInsets.all(16) + context.mediaQueryPadding,
            separatorBuilder: (context, index) => const Gap(16),
            itemBuilder: (context, index) {
              final plan = state.list[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CachedImage(
                      plan.image,
                      fit: BoxFit.fill,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: CommonText.bold(plan.name.toUpperCase(), size: 20),
                          ),
                          CommonText.bold(
                            "${currency.currencyText}${plan.price.toStringAsFixed(2)}",
                            size: 20,
                            color: AppColor.green,
                          ),
                        ],
                      ),
                    ),
                    const Divider(indent: 16, endIndent: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Html(
                            data: plan.details,
                            style: {
                              "ul": Style(
                                padding: HtmlPaddings.only(bottom: 16),
                              ),
                              "li": Style(
                                color: AppColor.textPrimaryMedium,
                                fontSize:  FontSize(14),
                                fontWeight: FontWeight.w600,
                                fontFamily: kFontFamily,
                                listStyleType: ListStyleType.disc,
                              ),
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 16, 8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.green,
                              foregroundColor: AppColor.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            onPressed: () => BlocProvider.of<PricingCubit>(context).purchasePlan(index),
                            child: Text(S.of(context).btnBuyNow),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );

          /*return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => const Gap(16),
            itemCount: state.listPricingData.length,
            itemBuilder: (context, index) {
              var data = state.listPricingData[index];
              return Card(
                color: listPricingColors[index],
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Column(
                    children: [
                      CommonText.semiBold(data.title.toUpperCase() + " PACK", size: 20, color: AppColor.white),
                      const Gap(16),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColor.white, width: 2),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          style: const TextStyle(
                                            color: AppColor.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: data.totalDesignLimit.toString(),
                                              style: const TextStyle(fontWeight: FontWeight.w700),
                                            ),
                                            const WidgetSpan(child: SizedBox(width: 8)),
                                            const TextSpan(text: "Designs"),
                                          ],
                                        ),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text.rich(
                                          TextSpan(
                                            style: const TextStyle(
                                              color: AppColor.white,
                                              fontSize: 8,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            children: [
                                              if (data.dailyDesignLimit > 1) ...[
                                                TextSpan(text: "Daily ${data.dailyDesignLimit} Designs"),
                                                const TextSpan(text: " x "),
                                              ],
                                              TextSpan(text: "${data.validityInDays} Days Validity"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadiusDirectional.horizontal(start: Radius.circular(8)),
                                    color: AppColor.white,
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    alignment: Alignment.center,
                                    children: [
                                      Center(
                                        child: CommonText.bold(
                                          currency.currencyText + " " + data.price.round().toString(),
                                          size: 20,
                                          color: listPricingColors[index],
                                        ),
                                      ),
                                      PositionedDirectional(
                                        child: CommonText.bold(
                                          "\$" + data.priceInUsd.round().toString(),
                                          size: 14,
                                          color: listPricingColors[index],
                                        ),
                                        end: 0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppColor.white,
                          onPrimary: listPricingColors[index],
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        onPressed: () => BlocProvider.of<PricingCubit>(context).buy(index),
                        child: CommonText.medium(S.of(context).btnBuyNow, size: 14, color: listPricingColors[index]),
                      )
                    ],
                  ),
                ),
              );
            },
          );*/
        }),
      ),
    );
  }
}
