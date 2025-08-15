part of 'main_view.dart';

class MainState extends Equatable {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int currentIndex;
  final int cartCount;
  final List<int> navigationHistory;
  final NotchBottomBarController controller;

  const MainState(
    this.scaffoldKey,
    this.controller, {
    this.currentIndex = 0,
    this.cartCount = 0,
    this.navigationHistory = const [0],
  });

  @override
  List<Object?> get props => [currentIndex, cartCount, navigationHistory];

  MainState copyWith({
    int? currentIndex,
    int? cartCount,
    List<int>? navigationHistory,
  }) {
    return MainState(
      scaffoldKey,
      controller,
      currentIndex: currentIndex ?? this.currentIndex,
      cartCount: cartCount ?? this.cartCount,
      navigationHistory: navigationHistory ?? this.navigationHistory,
    );
  }
}
