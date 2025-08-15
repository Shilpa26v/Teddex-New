import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';
import 'package:teddex/app/app.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/widgets/widgets.dart';

part 'my_subscription_cubit.dart';

part 'my_subscription_state.dart';

class MySubscriptionView extends StatefulWidget {
  const MySubscriptionView({Key? key}) : super(key: key);

  static const routeName = "/my_subscription_view";

  static Widget builder(BuildContext context) {
    const state = MySubscriptionState();
    return BlocProvider(
      create: (context) => MySubscriptionCubit(context, state),
      child: const MySubscriptionView(),
    );
  }

  @override
  _MySubscriptionViewState createState() => _MySubscriptionViewState();
}

class _MySubscriptionViewState extends State<MySubscriptionView> {
  @override
  Widget build(BuildContext context) {
    final currency = AppCubit.of(context, listen: true).currency;

    return Scaffold(
      appBar: AppBar(
        leading: const BackIcon(),
        title: Text(S.of(context).titleMySubscription),
      ),
      body: BlocBuilder<MySubscriptionCubit, MySubscriptionState>(
        builder: (context, state) {
          if (state.plan == null || state.plan!.isEmpty) {
            if (state.isLoading) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              return const SizedBox.shrink();
            }
          }
          return ListView.separated(
            itemCount: state.plan!.length,
            padding: const EdgeInsets.all(16) + context.mediaQueryPadding,
            separatorBuilder: (context, index) => const Gap(16),
            itemBuilder: (context, index) {
              final plan =  state.plan![index];
              return Card(
                margin: const EdgeInsets.all(16),
                color: AppColor.white,
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: CommonText.semiBold("${plan.name} Pack", size: 20)),
                          CommonText.bold(
                            "${currency.currencyText} ${plan.price.toStringAsFixed(2)}",
                            size: 20,
                            color: AppColor.green,
                          ),
                        ],
                      ),
                      const Gap(16),
                      const Divider(color: AppColor.grey, thickness: 0.5),
                      const Gap(16),
                      Row(
                        children: [
                          Expanded(
                            child: CommonText.semiBold(
                              S.of(context).purchaseDate,
                              size: 14,
                              color: AppColor.textPrimaryMedium,
                            ),
                          ),
                          Expanded(
                            child: CommonText.bold(
                              plan.created.parseUtcDateTime().toLocalString("dd MMMM, y"),
                              size: 16,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          Expanded(
                            child: CommonText.semiBold(
                              S.of(context).designsAllowed,
                              size: 14,
                              color: AppColor.textPrimaryMedium,
                            ),
                          ),
                          Expanded(
                            child: CommonText.bold(
                              S.of(context).designs(plan.totalDownload),
                              size: 16,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          Expanded(
                            child: CommonText.semiBold(
                              S.of(context).designsDownloaded,
                              size: 14,
                              color: AppColor.textPrimaryMedium,
                            ),
                          ),
                          Expanded(
                            child: CommonText.bold(
                              S.of(context).designs(plan.userDownload),
                              size: 16,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          Expanded(
                            child: CommonText.semiBold(
                              S.of(context).remainingDownloads,
                              size: 14,
                              color: AppColor.textPrimaryMedium,
                            ),
                          ),
                          Expanded(
                            child: CommonText.bold(
                              S.of(context).designs(plan.totalDownload - plan.userDownload),
                              size: 16,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          Expanded(
                            child: CommonText.semiBold(
                              S.of(context).planStatus,
                              size: 14,
                              color: AppColor.textPrimaryMedium,
                            ),
                          ),
                          Expanded(
                            child: CommonText.bold(
                              plan.planStatus,
                              size: 16,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
