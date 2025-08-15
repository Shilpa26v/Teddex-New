part of 'app.dart';

class AppCubit extends BaseCubit<AppState> {
  late final StreamSubscription _subscription;

  AppCubit(BuildContext context) : super(context, AppState(GlobalKey<NavigatorState>(), user: AppPref.user)) {
    _subscription = eventBus.listen(onBusEvent);
    Timer.run(() {
      if (!AppPref.isGuestUser && AppPref.isLogin) _getProfile();
    });
  }

  static AppCubit of(BuildContext context, {bool listen = false}) {
    return BlocProvider.of<AppCubit>(context, listen: listen);
  }

  Currency get currency => const Currency(id: 2, code: "INR", rate: 1.0, symbol: "fa fa-inr", currencyText: "\u20b9");

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  Future<void> getCurrencyList() async {
    var response = await processApi(() => apiClient.getCurrencies());
    response?.data.let((it) {
      var selectedCurrencySymbol = AppPref.currencySymbol;
      var selectedCurrency = it.firstWhere((element) => element.code.toUpperCase() == selectedCurrencySymbol);
      emit(state.copyWith(listCurrency: it, selectedCurrency: selectedCurrency.id));
    });
  }



  Future<void> getCommonPageLink() async {
    var response = await processApi(() => apiClient.getCommonPages());
    response?.data.let((it) {
      AppPref.commonPage = it;
      emit(state.copyWith(commonPage: it));
      Log.debug("dome..${state.commonPage}");
    });
  }

  void _updateSelectedCurrency() {
    var selectedCurrencySymbol = AppPref.currencySymbol;
    var selectedCurrency =
        state.listCurrency.firstWhere((element) => element.code.toUpperCase() == selectedCurrencySymbol);
    emit(state.copyWith(selectedCurrency: selectedCurrency.id));
  }

  Future<void> _getProfile() async {
    var response = await processApi(() => apiClient.getProfile());
    response?.data.let((it) {
      AppPref.user = it;
      emit(state.copyWith(user: it));
    });
  }

  void onBusEvent(BusEvent event) {
    switch (event.tag) {
      case "user_login":
      case "user_updated":
        _getProfile();
        break;
      case "user_logout":
        emit(AppState(state.navigatorKey, listCurrency: state.listCurrency, selectedCurrency: state.selectedCurrency));
        break;
      case "currency_updated":
        _updateSelectedCurrency();
        break;
    }
  }

  @override
  void onUserUnauthenticated() {
    AppPref.clear();
    state.navigatorKey.currentState?.pushNamedAndRemoveUntil(LoginView.routeName, (route) => false);
  }
}
