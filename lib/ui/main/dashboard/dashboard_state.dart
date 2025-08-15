part of 'dashboard_view.dart';

class DashboardState extends Equatable {
  final Dashboard? dashboard;
  final List<Category> categoryList;
  final List<HomeBanner>? homeBannerList;
  final PageController pageController;
  final bool isLoading;

  const DashboardState(
    this.pageController, {
    this.categoryList = const [],
    this.dashboard,
    this.homeBannerList = const [],
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [
        dashboard,
        categoryList,
        pageController,
        homeBannerList,
        isLoading,
      ];

  DashboardState copyWith({
    List<Category>? categoryList,
    Dashboard? dashboard,
    List<HomeBanner>? homeBannerList,
    bool? isLoading,
  }) {
    return DashboardState(
      pageController,
      categoryList: categoryList ?? this.categoryList,
      dashboard: dashboard ?? this.dashboard,
      homeBannerList: homeBannerList ?? this.homeBannerList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
