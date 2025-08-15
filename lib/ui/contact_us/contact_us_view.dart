import 'dart:async';

import 'package:teddex/base/base.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/widgets/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';

part 'contact_us_cubit.dart';

part 'contact_us_state.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({Key? key}) : super(key: key);

  static const routeName = "/dynamic_web_view";

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactUsCubit(context, const ContactUsState()),
      child: const ContactUsView(),
    );
  }

  @override
  _ContactUsViewState createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactUsCubit, ContactUsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        return CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: BlocProvider.of<ContactUsCubit>(context).onRefresh,
            ),
            const SliverGap(8),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final faq = state.list[index];
                  return ExpansionTile(
                    title: CommonText.medium(faq.que,size: 16),
                    children: <Widget>[
                      ListTile(
                        title:  Html(
                          data: faq.ans,
                        ),
                      ),
                    ],
                  );
                },
                childCount: state.list.length,
              ),
            ),
            const SliverGap(16),
          ],
        );
      },
    );
  }
}
