part of 'app.dart';

class AppState extends Equatable {
  final User? user;
  final CommonPage? commonPage;
  final List<Currency> listCurrency;
  final int selectedCurrency;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  List<Object?> get props => [user, listCurrency, selectedCurrency,commonPage];

  const AppState(
    this.navigatorKey, {
    this.user,
    this.listCurrency = const [],
    this.commonPage,
    this.selectedCurrency = -1,
  });

  AppState copyWith({
    User? user,
    List<Currency>? listCurrency,
    CommonPage? commonPage,
    int? selectedCurrency,
    int? cartCount,
  }) {
    return AppState(
      navigatorKey,
      user: user ?? this.user,
      commonPage: commonPage ?? this.commonPage,
      listCurrency: listCurrency ?? this.listCurrency,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
    );
  }
}
