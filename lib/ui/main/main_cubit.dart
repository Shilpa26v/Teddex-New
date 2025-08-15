part of 'main_view.dart';

class MainCubit extends BaseCubit<MainState> {
  StreamSubscription? _subscription;

  MainCubit(
    BuildContext context,
    MainState initialState,
  ) : super(context, initialState) {
    listStreamSubscription.add(eventBus.listen(onEvent));
    Timer.run(_saveContact);
    if (!AppPref.isGuestUser && AppPref.isLogin) {
      Timer.run(_getCartItems);
    }
    _subscription = eventBus.listen(_onBusEvent);
    emit(state.copyWith(cartCount: AppPref.cartCount));
  }

  _onBusEvent(BusEvent event) {
    if (event.tag == "cart_updated") {
      emit(state.copyWith(cartCount: AppPref.cartCount));
    }
  }

  Future<void> _getCartItems() async {
    var response = await processApi(() => apiClient.getCartItems({}), doShowLoader: false);
    emit(state.copyWith(cartCount: response?.data.length ?? 0));
    AppPref.cartCount = response?.data.length ?? AppPref.cartCount;
  }

  Future<void> _saveContact() async {
    if (await ContactsPermissionUtils(context).checkPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts();
      if (contacts.isEmpty) {
        var contact = Contact(
          phones: [
            Phone(
              AppConfig.mobileNumber,
              label: PhoneLabel.work,
            )
          ],
        );
        await FlutterContacts.insertContact(contact);
      }
    }
  }

  void onEvent(BusEvent event) {
    switch (event.tag) {
      case "update_profile":
        break;
      case "app_in_foreground":
        break;
      case "app_in_background":
        break;
      case "product_downloaded":
        changeIndex(3);
        break;
    }
  }

  void changeIndex(int index) {
    if (index != state.currentIndex) {
      var list = List<int>.from(state.navigationHistory);
      list.add(index);
      emit(state.copyWith(currentIndex: index, navigationHistory: list));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<bool> onBackTap() async {
    Log.debug("onback");
    if (state.navigationHistory.length > 1) {
      var list = List<int>.from(state.navigationHistory);
      list.removeLast();
      var currentIndex = list.last;
      emit(state.copyWith(currentIndex: currentIndex, navigationHistory: list));
      return false;
    } else {
      return true;
    }
  }

  Future<void> logout() async {
    Navigator.of(context).pop();
    var isContinue = await showAppDialog<bool>(
      context: context,
      title: S.current.logoutTitle,
      content: S.current.logoutDesc,
      positiveButton: AppDialogButton(
        label: S.current.btnYes,
        onPressed: () => Navigator.of(context).pop(true),
      ),
      negativeButton: AppDialogButton(
        label: S.current.btnNo,
        onPressed: () => Navigator.of(context).pop(false),
      ),
      barrierDismissible: false,
    );

    if (isContinue == true) {
      eventBus.fire("user_logout");
      AppPref.isLogin = false;
      AppPref.userToken = "";
      AppPref.user = null;
      AppPref.isGuestUser = false;
      Navigator.of(context).pushNamedAndRemoveUntil(LoginView.routeName, (_) => false);
    }
  }

  void openCart() {
    if (userLoggedIn()) {
      Navigator.of(context).pushNamed(CartView.routeName);
    }
  }

  void onContactUsTap() {
    Navigator.of(context).pushNamed(
      WebView.routeName,
      arguments: WebViewArguments(
        title: S.of(context).drawerContactUs,
        url: AppPref.commonPage?.contact ?? "https://www.flutter.dev",
      ),
    );
  }

  void openWhatsapp() {
    launchUrl("https://wa.me/${AppConfig.mobileNumber.replaceAll("+", "")}");
  }

  void openSearch() {
    Navigator.of(context).pushNamed(SearchView.routeName);
  }

  void selectCurrency() {
    showDialog(
      context: context,
      builder: CurrencySelectionView.builder,
      routeSettings: const RouteSettings(name: CurrencySelectionView.routeName),
    );
  }
}
