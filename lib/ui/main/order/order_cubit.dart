part of 'order_view.dart';

class OrderCubit extends BaseCubit<OrderState> {
  OrderCubit(BuildContext context, OrderState initialState) : super(context, initialState) {
    Timer.run(() {
      if (userLoggedIn()) {
        _getOrders();
      }
    });
  }

  Future<void> download(int index, context) async {
    var isContinue = await showAppDialog<bool>(
      context: context,
      title: S.current.downloadTitle,
      content: S.current.downloadDescription,
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
      var order = state.list[index];

        emit(state.copyWith(progressController: StreamController<double>.broadcast()));
        state.progressController.stream.listen((progress) {
          if (progress != null) {
            int percent = ((double.parse(progress.toString())).toInt());
            // state.progressController.close();
            if (percent == 100) {
              state.progressController.close();
            }
            bool isDownload=percent>=100?false:true;
            emit(state.copyWith(progress: percent>=100?0.0:percent.toDouble(), isDownloading: isDownload));
          }
        });

        downloadFile(context, order.downloadLink, state.list[index].designId.toString(), state.progressController);
    }
  }


  Future<void> addReview(int index) async {
    var order = state.list[index];
    var review = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: ReviewView.builder,
      routeSettings: RouteSettings(
        arguments: ReviewArguments(productId: order.designId, msg: order.reviewMsg, star: order.star),
        name: ReviewView.routeName,
      ),
    );
    if (review != null) {
      order = order.copyWith(
        star: review["star"],
        reviewMsg: review["message"],
      );
      final list = List<Order>.from(state.list)
        ..[index] = order;
      emit(state.copyWith(list: list));
    }
  }


  bool onScrollNotification(ScrollNotification notification) {
    if (notification.metrics.maxScrollExtent <= notification.metrics.pixels) {
      onLoadMore();
    }
    return false;
  }

  Future<void> onRefresh() async {
    Log.debug('onnRefresh');
    if (state.isLoading) return;
    emit(state.copyWith(isRefreshing:true,list: []));
    return _getOrders();
  }

  Future<void> onLoadMore() async {
    if (state.isLoading || state.reachAtEnd) return;
    return _getOrders();
  }

  Future<void> _getOrders({bool isOnRefresh=false}) async {
    if(isOnRefresh){
      emit(state.copyWith(isRefreshing: true));
    }else {
      emit(state.copyWith(isLoading: true));
    }

    var response = await processApi(() => apiClient.getOrders(offset: state.list.length));
    emit(state.copyWith(
      list: [...state.list, ...response?.data ?? []],
      isLoading: false,
      isRefreshing:false,
      reachAtEnd: response != null && response.data.length < AppConfig.paginationLimit,
    ));
  }

  void openDetails(int index) {
    Navigator.of(context).pushNamed(
      ProductDetailView.routeName,
      arguments: ProductDetailArguments(productId: state.list[index].designId),
    );
  }
}
