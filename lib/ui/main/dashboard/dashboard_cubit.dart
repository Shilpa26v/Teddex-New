part of 'dashboard_view.dart';

class DashboardCubit extends BaseCubit<DashboardState> {
  Timer? _timer;
  StreamSubscription? _subscription;

  DashboardCubit(BuildContext context, DashboardState initialState) : super(context, initialState) {
    Timer.run(_getDashboard);
    Timer.run(_getBanner);
    Timer.run(_getCategories);
    _subscription = eventBus.listen(_onBusEvent);
  }

  _onBusEvent(BusEvent event) {
    if (event.tag == "currency_updated") {
      _getDashboard();
    }
  }

  void _autoScroll(Timer timer) {
    if (state.pageController.hasClients) {
      if ((state.pageController.page?.toInt() ?? 0) >= state.homeBannerList!.length - 1) {
        state.pageController.jumpToPage(0);
      } else {
        state.pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear);
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), _autoScroll);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _subscription?.cancel();
    return super.close();
  }

  void openProductDetail(Product product) {
    Navigator.of(context).pushNamed(ProductDetailView.routeName, arguments: ProductDetailArguments(productId: product.id));
  }

  void didPushNext() {
    _timer?.cancel();
  }

  void didPopNext() {
    _startTimer();
  }

  Future<void> onRefresh() async {
    if (state.isLoading) return;
    return _getDashboard();
  }

  Future<void> _getDashboard() async {
    emit(state.copyWith(isLoading: true));
    var response = await processApi(() => apiClient.getDashboard());
    emit(state.copyWith(dashboard: response?.data, isLoading: false));
  }

  Future<void> _getCategories() async {
    emit(state.copyWith(isLoading: true));
    var response = await processApi(() => apiClient.getCategory());
    emit(state.copyWith(categoryList: response?.data, isLoading: false));
  }

  Future<void> _getBanner() async {
    emit(state.copyWith(isLoading: true));
    var response = await processApi(() => apiClient.getHomeBanner());
    emit(state.copyWith(homeBannerList: response?.data, isLoading: false));
    response?.data.let((it) {
      _startTimer();
    });
  }

  void onCategorySelected(Category category) {
    if (category.subCategory.isEmpty) {
      Navigator.of(context).pushNamed(
        ProductListView.routeName,
        arguments: ProductListArguments(cId: category.id,categoryName: category.name),
      );
    } else {
      Navigator.of(context).pushNamed(
        CategoryListView.routeName,
        arguments: CategoryListArguments(category: category),
      );
    }
  }
}
