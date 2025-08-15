import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/widgets/widgets.dart';

part 'review_list_bloc.dart';

part 'review_list_state.dart';

class ReviewArguments {
  final List<Review> listReview;

  const ReviewArguments({
    required this.listReview,
  });
}

class ReviewListView extends StatefulWidget {
  const ReviewListView({Key? key}) : super(key: key);

  static const routeName = "/review_list_view";

  static Widget builder(BuildContext context) {
    assert(context.args != null && context.args is ReviewArguments);
    final state = ReviewListState(listReview: (context.args as ReviewArguments).listReview);
    return BlocProvider(
      create: (context) => ReviewListCubit(context, state),
      child: const ReviewListView(),
    );
  }

  @override
  _ReviewListViewState createState() => _ReviewListViewState();
}

class _ReviewListViewState extends State<ReviewListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: const BackIcon(),
            title: Text(S.of(context).titleReviews),
            pinned: true,
            floating: true,
          ),
          BlocBuilder<ReviewListCubit, ReviewListState>(
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var initialIndex = index ~/ 2;
                    if (index.isEven) {
                      var review = state.listReview[initialIndex];
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
                  childCount: max(0, state.listReview.length * 2 - 1),
                  semanticIndexCallback: (child, index) => index ~/ 2,
                ),
              );
            },
          ),
          SliverGap(context.mediaQueryPadding.bottom + 16),
        ],
      ),
    );
  }
}
