part of 'order_view.dart';

class OrderState extends Equatable {
  final List<Order> list;
  final bool isLoading;
  final bool isRefreshing;
  final bool isDownloading;
  final double? progress;
  final bool reachAtEnd;
  final StreamController progressController;

  const OrderState(
    this.progressController, {
    this.list = const [],
    this.isLoading = false,
    this.isDownloading = false,
    this.isRefreshing = false,
    this.reachAtEnd = false,
    this.progress,
  });

  @override
  List<Object?> get props =>
      [list, isLoading, isRefreshing, progress, isDownloading, reachAtEnd, progressController];

  OrderState copyWith(
      {List<Order>? list,
      bool? isLoading,
      bool? reachAtEnd,
      bool? isRefreshing,
      bool? isDownloading,
      double? progress,
      StreamController? progressController}) {
    return OrderState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      reachAtEnd: reachAtEnd ?? this.reachAtEnd,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isDownloading: isDownloading ?? this.isDownloading,
      progress: progress ?? this.progress,
      progressController ?? this.progressController,
    );
  }
}
