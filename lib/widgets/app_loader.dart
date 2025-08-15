import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppLoader {
  static const routeName = "/loading_dialog";

  static bool _isVisible = false;

  static void show(BuildContext context) {
    if (_isVisible) return;
    showDialog(
      context: context,
      useSafeArea: false,
      routeSettings: const RouteSettings(name: routeName),
      builder: (context) => WillPopScope(
        onWillPop: () => Future.value(false),
        child: const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.zero,
          child: Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CupertinoActivityIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
    _isVisible = true;
  }

  static void dismiss(BuildContext context) {
    if (_isVisible) {
      Navigator.of(context).pop();
      _isVisible = false;
    }
  }
}
