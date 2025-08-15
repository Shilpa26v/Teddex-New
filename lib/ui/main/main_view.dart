import 'dart:async';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/config/app_config.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/pref/app_pref.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/auth/create_account/create_account_view.dart';
import 'package:teddex/ui/auth/login/login_view.dart';
import 'package:teddex/ui/cart/cart_view.dart';
import 'package:teddex/ui/in_app_web_view/web_view.dart';
import 'package:teddex/ui/main/currency_selection/currency_selection_view.dart';
import 'package:teddex/ui/main/dashboard/dashboard_view.dart';
import 'package:teddex/ui/main/favourites/favourites_view.dart';
import 'package:teddex/ui/main/order/order_view.dart';
import 'package:teddex/ui/my_profile/my_profile_view.dart';
import 'package:teddex/ui/search/search_view.dart';
import 'package:teddex/utils/permission/contacts_permission_utils.dart';
import 'package:teddex/widgets/widgets.dart';

part 'drawer_view.dart';

part 'main_cubit.dart';

part 'main_state.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  static const routeName = "/main_view";

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(context, MainState(GlobalKey<ScaffoldState>(), NotchBottomBarController(index: 0))),
      child: const MainView(),
    );
  }

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    final initialState = BlocProvider.of<MainCubit>(context).state;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop)=> BlocProvider.of<MainCubit>(context).onBackTap,
      child: Scaffold(
        key: initialState.scaffoldKey,
        appBar: AppBar(title: Text( S.of(context).appName,),
          centerTitle: false,
          leading: ActionIcon(
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            onPressed: () => initialState.scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu,size: 32,),
          ),
          actions: [
            // ActionIcon(
            //   icon: SquareSvgImageFromAsset(AppImages.imagesCurrency),
            //   tooltip: S.of(context).tooltipCurrency,
            //   onPressed: BlocProvider.of<MainCubit>(context).selectCurrency,
            // ),
            ActionIcon(
              icon: SquareSvgImageFromAsset(AppImages.imagesSearch),
              tooltip: S.of(context).tooltipSearch,
              onPressed: BlocProvider.of<MainCubit>(context).openSearch,
            ),
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
                      child: BlocSelector<MainCubit, MainState, int>(
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
              onPressed: BlocProvider.of<MainCubit>(context).openCart,
            ),
          ],
        ),
        body: Stack(
          children: [
            BlocSelector<MainCubit, MainState, int>(
              selector: (state) => state.currentIndex,
              builder: (context, currentIndex) {
                switch (currentIndex) {
                  case 0:
                    return DashboardView.builder(context);
                  case 1:
                    return FavouritesView.builder(context);
                  // case 2:
                  //   return PricingView.builder(context);
                  case 2:
                    return OrderView.builder(context);
                  // case 3:
                  //   return ContactUsView.builder(context);
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: context.select<MainCubit, int>((value) => value.state.currentIndex) == 0
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16, bottom: 16),
                      child: FloatingActionButton(
                        heroTag: "whatsapp",
                        backgroundColor: AppColor.whatsapp,
                        onPressed: BlocProvider.of<MainCubit>(context).openWhatsapp,
                        child: SquareSvgImageFromAsset(AppImages.imagesWhatsapp),
                      ),
                    )
                  : const SizedBox.shrink(),
            )
          ],
        ),
        drawer: const DrawerView(),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //  floatingActionButton: FloatingActionButton(
        //    backgroundColor: AppColor.primary,
        //    onPressed: () {
        //      BlocProvider.of<MainCubit>(context).changeIndex(2);
        //    },
        //    elevation: 0.0,
        //    child: CommonText.medium(S.of(context).tabPricing, color: AppColor.white),
        //  ),
        bottomNavigationBar: BlocSelector<MainCubit, MainState, int>(
          selector: (state) => state.currentIndex,
          builder: (context, currentIndex) {

            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewPadding.bottom > 0 ? MediaQuery.of(context).viewPadding.bottom : 0,
                  right: 0,
                  left: 0),
              child: SizedBox(
                height: 90,
                child: AnimatedNotchBottomBar(
                  removeMargins: true,
                  showShadow: false,
                  durationInMilliSeconds: 100,
                  color: AppColor.primary,
                  notchColor: AppColor.yellow,
                  notchBottomBarController: initialState.controller,
                  bottomBarItems: [
                    BottomBarItem(
                      inActiveItem: SquareSvgImageFromAsset(AppImages.imagesTabHomeUnselected),
                      activeItem: SquareSvgImageFromAsset(
                        AppImages.imagesTabHomeUnselected,
                        color: AppColor.white,
                      ),
                    ),
                    BottomBarItem(
                      inActiveItem: SquareSvgImageFromAsset(AppImages.imagesTabFavouriteUnselected),
                      activeItem: SquareSvgImageFromAsset(AppImages.imagesTabFavouriteUnselected,    color: AppColor.white,),
                    ),
                    BottomBarItem(
                      inActiveItem: SquareSvgImageFromAsset(AppImages.imagesTabOrderUnselected),
                      activeItem: SquareSvgImageFromAsset(AppImages.imagesTabOrderUnselected, color: AppColor.white,),
                    ),
                    // BottomBarItem(
                    //   inActiveItem: SquareSvgImageFromAsset(AppImages.imagesTabHelpUnselected,),
                    //   activeItem: SquareSvgImageFromAsset(AppImages.imagesTabHelpUnselected, color: AppColor.white,),
                    // ),
                  ],
                  onTap: (int value) {
                    BlocProvider.of<MainCubit>(context).changeIndex(value);
                  }, kIconSize: 48, kBottomRadius: 2,
                ),
              ),
            );


          },
        ),
      ),
    );
  }
}
