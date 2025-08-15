import 'dart:io';

import 'package:teddex/generated/l10n.dart';
import 'package:teddex/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:teddex/app/app.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/pref/app_pref.dart';
import 'package:teddex/ui/auth/login/login_view.dart';
import 'package:teddex/ui/main/main_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

import '../../resources/resources.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  static const routeName = "/";

  static Widget builder(BuildContext context) {
    return const SplashView();
  }

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 42), child: Image.asset(AppImages.imagesAppLogo,width: context.width*0.7,height: context.width*0.7,)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    await AppCubit.of(context).getCommonPageLink();
    if (AppCubit.of(context).state.commonPage != null &&
        AppCubit.of(context).state.commonPage!.versionIos != null &&
        AppCubit.of(context).state.commonPage!.versionAndroid != null) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      var buildNumber = Platform.isIOS
          ? AppCubit.of(context).state.commonPage!.versionIos
          : AppCubit.of(context).state.commonPage!.versionAndroid;

      Version currentVersion = Version.parse(packageInfo.version);
      Version latestVersion = Version.parse(buildNumber!);

      if (currentVersion < latestVersion) {
        // ignore: use_build_context_synchronously
        await showAppDialog<bool>(
          context: context,
          isEnableBack: false,
          title: S.current.updateAppTitle,
          content: S.current.updateAppDesc,
          positiveButton: AppDialogButton(
            label: S.current.btnYes,
            onPressed: () async {
              const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.tedeex.mshop';
              //final String appStoreUrl = 'https://apps.apple.com/app/your_app_name/idyour_app_id';
              await launchUrl(playStoreUrl);
            },
          ),
          negativeButton: AppDialogButton(
            label: S.current.btnCancel,
            onPressed: () => exit(0),
          ),
          barrierDismissible: false,
        );
        return;
      }
    }
    if (AppPref.isLogin || AppPref.isGuestUser) {
      Navigator.of(context).pushReplacementNamed(MainView.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(LoginView.routeName);
    }

    // if (AppCubit.of(context).state.listCurrency.isNotEmpty) {
    //
    // }
    // AppCubit.of(context).getCurrencyList().then((value) async {
    //
    // });
  }
}
