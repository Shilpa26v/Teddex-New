part of 'main_view.dart';

class DrawerItem {
  final String title;
  final VoidCallback onPressed;
  final Widget leading;

  const DrawerItem({
    required this.title,
    required this.onPressed,
    required this.leading,
  });
}

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listDrawerItem = [
      if (AppPref.isLogin) ...[
        DrawerItem(
          leading: Image.asset(AppImages.profile),
          title: S.of(context).drawerMyProfile,
          onPressed: () => Navigator.of(context).popAndPushNamed(MyProfileView.routeName),
        ),
        // DrawerItem(
        //   title: S.of(context).drawerChangePassword,
        //   onPressed: () => Navigator.of(context).popAndPushNamed(ChangePasswordView.routeName),
        // ),
        DrawerItem(
          leading: Image.asset(AppImages.download),
          title: S.of(context).drawerDesignDownload,
          onPressed: () {
            BlocProvider.of<MainCubit>(context).changeIndex(2);
            Navigator.of(context).pop();
          },
        ),
        // DrawerItem(
        //   title: S.of(context).drawerMySubscriptionPlan,
        //   onPressed: () => Navigator.of(context).popAndPushNamed(MySubscriptionView.routeName),
        // ),
      ] else ...[
        DrawerItem(
          leading: Image.asset(AppImages.login),
          title: S.of(context).drawerLogin,
          onPressed: () => Navigator.of(context).pushNamed(LoginView.routeName,arguments: const LoginViewArguments(isAllowBack: true)),
        ),
        DrawerItem(
          leading: Image.asset(AppImages.createAcc),
          title: S.of(context).drawerCreateAccount,
          onPressed: () => Navigator.of(context).pushNamed(CreateAccountView.routeName),
        ),
      ],
      DrawerItem(
        leading: Image.asset(AppImages.contactUs),
        title: S.of(context).drawerContactUs,
        onPressed: () => Navigator.of(context).popAndPushNamed(
          WebView.routeName,
          arguments: WebViewArguments(
            title: S.of(context).drawerContactUs,
            url: AppPref.commonPage?.contact ?? "https://www.flutter.dev",
          ),
        ),
      ),
      DrawerItem(
        leading: Image.asset(AppImages.aboutUs),
        title: S.of(context).drawerAboutUs,
        onPressed: () => Navigator.of(context).popAndPushNamed(
          WebView.routeName,
          arguments: WebViewArguments(
            title: S.of(context).drawerAboutUs,
            url: AppPref.commonPage?.about ?? "https://www.flutter.dev",
          ),
        ),
      ),
      DrawerItem(
        leading: Image.asset(AppImages.privacy),
        title: S.of(context).drawerPrivacy,
        onPressed: () => Navigator.of(context).popAndPushNamed(
          WebView.routeName,
          arguments: WebViewArguments(
            title: S.of(context).drawerPrivacy,
            url: AppPref.commonPage?.privacy ?? "https://www.flutter.dev",
          ),
        ),
      ),
      DrawerItem(
        leading: Image.asset(AppImages.terms),
        title: S.of(context).drawerTermsConditions,
        onPressed: () => Navigator.of(context).popAndPushNamed(
          WebView.routeName,
          arguments: WebViewArguments(
            title: S.of(context).drawerTermsConditions,
            url: AppPref.commonPage?.term ?? "https://www.flutter.dev",
          ),
        ),
      ),
      DrawerItem(
          leading: Image.asset(AppImages.share),
          title: S.of(context).drawerShare,
          onPressed: () {
            Share.share('Check out Zoom Embroidery app on PlayStore :\n'
                'https://play.google.com/store/apps/details?id=com.tedeex.mshop');
          }),
      if (AppPref.isLogin)
        DrawerItem(
            leading: Image.asset(AppImages.logout),
            title: S.of(context).drawerLogout,
            onPressed: BlocProvider.of<MainCubit>(context).logout),
    ];

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(color: AppColor.greyLight),
            child: Center(
              child: AppPref.isGuestUser
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(AppImages.imagesAppLogo, width: 100),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonText.semiBold(AppPref.user?.name ?? "", size: 18),
                        CommonText.semiBold(AppPref.user?.mobile ?? "", size: 18),
                      ],
                    ),
            ),
          ),
          Expanded(
            child: Theme(
              data: context.theme.copyWith(
                highlightColor: AppColor.greyLight.withAlpha(150),
                splashColor: AppColor.greyLight,
              ),
              child: MediaQuery(
                data: MediaQuery.of(context).removePadding(removeTop: true),
                child: ListView.builder(
                  itemCount: listDrawerItem.length,
                  itemBuilder: (context, index) => ListTile(
                    horizontalTitleGap: -8.0,
                    leading: SizedBox(height: 20, width: 20, child: listDrawerItem[index].leading),
                    title: Text(listDrawerItem[index].title),
                    onTap: listDrawerItem[index].onPressed,
                    style: ListTileStyle.drawer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
