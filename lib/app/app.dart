import 'dart:async';

import 'package:teddex/helpers/src/event_bus.dart';
import 'package:teddex/ui/main/pricing/pricing_view.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/pref/app_pref.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/auth/create_account/create_account_view.dart';
import 'package:teddex/ui/auth/forgot_password/forgot_password_view.dart';
import 'package:teddex/ui/auth/login/login_view.dart';
import 'package:teddex/ui/auth/reset_password/reset_password_view.dart';
import 'package:teddex/ui/auth/verification/verification_view.dart';
import 'package:teddex/ui/cart/cart_view.dart';
import 'package:teddex/ui/category_list/category_list_view.dart';
import 'package:teddex/ui/change_password/change_password_view.dart';
import 'package:teddex/ui/in_app_web_view/web_view.dart';
import 'package:teddex/ui/main/main_view.dart';
import 'package:teddex/ui/my_profile/my_profile_view.dart';
import 'package:teddex/ui/my_subscription/my_subscription_view.dart';
import 'package:teddex/ui/product_detail/image_slider/image_slider_view.dart';
import 'package:teddex/ui/product_detail/product_detail_view.dart';
import 'package:teddex/ui/product_detail/review_list/review_list_view.dart';
import 'package:teddex/ui/product_list/product_list_view.dart';
import 'package:teddex/ui/search/search_view.dart';
import 'package:teddex/ui/splash/splash_view.dart';
import 'package:teddex/ui/success/success_view.dart';

part 'app_cubit.dart';
part 'app_state.dart';

class TedeexEmbroideryApp extends StatefulWidget {
  const TedeexEmbroideryApp({Key? key}) : super(key: key);

  @override
  _TedeexEmbroideryAppState createState() => _TedeexEmbroideryAppState();
}

class _TedeexEmbroideryAppState extends State<TedeexEmbroideryApp> with WidgetsBindingObserver {
  EventBus eventBus = GetIt.I.get<EventBus>();
  ConnectivityHelper connectivityHelper = GetIt.I.get<ConnectivityHelper>();
  late final RouteObserver _routeObserver;

  @override
  void initState() {
    _routeObserver = RouteObserver();
    GetIt.I.registerSingleton(_routeObserver);
    WidgetsBinding.instance.addObserver(this);
    connectivityHelper.initialize();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    connectivityHelper.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        eventBus.fire("app_in_foreground");
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        eventBus.fire("app_in_background");
        break;
      case AppLifecycleState.hidden:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      navigatorKey: context.select<AppCubit, GlobalKey<NavigatorState>>((cubit) => cubit.state.navigatorKey),
      scrollBehavior: const CupertinoScrollBehavior(),
      navigatorObservers: [_routeObserver],
      restorationScopeId: "tedeex",
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      routes: routes,
    );
  }

  Map<String, WidgetBuilder> get routes => const {
        SplashView.routeName: SplashView.builder,
        MainView.routeName: MainView.builder,
        LoginView.routeName: LoginView.builder,
        CreateAccountView.routeName: CreateAccountView.builder,
        VerificationView.routeName: VerificationView.builder,
        ForgotPasswordView.routeName: ForgotPasswordView.builder,
        ResetPasswordView.routeName: ResetPasswordView.builder,
        CategoryListView.routeName: CategoryListView.builder,
        ProductListView.routeName: ProductListView.builder,
        ProductDetailView.routeName: ProductDetailView.builder,
        ImageSliderView.routeName: ImageSliderView.builder,
        ReviewListView.routeName: ReviewListView.builder,
        WebView.routeName: WebView.builder,
        CartView.routeName: CartView.builder,
        ChangePasswordView.routeName: ChangePasswordView.builder,
        MyProfileView.routeName: MyProfileView.builder,
        SearchView.routeName: SearchView.builder,
        MySubscriptionView.routeName: MySubscriptionView.builder,
        SuccessView.routeName: SuccessView.builder,
        FilterView.routeName: FilterView.builder,
        PricingView.routeName: PricingView.builder,
      };
}
