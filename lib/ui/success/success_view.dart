import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/main/main_view.dart';
import 'package:teddex/ui/my_subscription/my_subscription_view.dart';
import 'package:teddex/widgets/widgets.dart';

class SuccessArguments {
  final String type;

  const SuccessArguments({required this.type});
}

class SuccessView extends StatefulWidget {
  final SuccessArguments arguments;

  const SuccessView({Key? key, required this.arguments}) : super(key: key);

  static const routeName = "/success_view";

  static Widget builder(BuildContext context) {
    assert(context.args != null && context.args is SuccessArguments);
    var args = context.args as SuccessArguments;
    return SuccessView(arguments: args);
  }

  @override
  _SuccessViewState createState() => _SuccessViewState();
}

class _SuccessViewState extends State<SuccessView> with AfterLayoutMixin {
  @override
  void initState() {
    GetIt.I<EventBus>().fire("update_profile");
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Timer(const Duration(milliseconds: 2500), () {
      switch (widget.arguments.type) {
        case "product":
          GetIt.I.get<EventBus>().fire("product_downloaded");
          Navigator.of(context).popUntil(ModalRoute.withName(MainView.routeName));
          break;
        case "subscription":
          Navigator.of(context)
              .pushNamedAndRemoveUntil(MySubscriptionView.routeName, ModalRoute.withName(MainView.routeName));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            constraints: const BoxConstraints.tightFor(height: 240, width: 240),
            child: SquareImageFromAsset(AppImages.success),
          ),
        ),
      ),
    );
  }
}
