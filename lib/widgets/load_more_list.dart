import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
import 'package:flutter/material.dart';

class LoadMoreListBuilder extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder loadingItemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final Clip clipBehavior;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final Future<void> Function()? onRefresh;
  final Future<void> Function() onLoadMore;
  final bool reachAtEnd;
  final bool isLoading;
  final Widget? emptyDataView;

  const LoadMoreListBuilder({
    required this.itemCount,
    required this.itemBuilder,
    required this.loadingItemBuilder,
    required this.onLoadMore,
    this.separatorBuilder,
    this.physics,
    this.controller,
    this.clipBehavior = Clip.hardEdge,
    this.padding,
    this.shrinkWrap = false,
    this.onRefresh,
    this.reachAtEnd = false,
    this.isLoading = false,
    this.emptyDataView,
    Key? key,
  }) : super(key: key);

  void onScrollEnd(ScrollNotification notification) {
    if (notification.metrics.pixels >= notification.metrics.maxScrollExtent &&
        !isLoading &&
        itemCount > 0 &&
        !reachAtEnd) {
      onLoadMore.call();
    }
  }

  bool get hasSeparator => separatorBuilder != null;

  int get childCount {
    var count = 0;
    if (itemCount == 0) {
      count = isLoading ? 10 : 0;
    } else {
      count = itemCount + (isLoading ? 5 : 0);
    }
    return hasSeparator ? ((count * 2) - 1) : count;
  }

  @override
  Widget build(BuildContext context) {
    var padding = this.padding ?? MediaQuery.of(context).padding;
    var topPadding = padding.copyWith(bottom: 0);
    var bottomPadding = padding.copyWith(top: 0);
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        onScrollEnd(notification);
        return false;
      },
      child: CustomScrollView(
        shrinkWrap: shrinkWrap,
        controller: controller,
        physics: physics,
        clipBehavior: clipBehavior,
        slivers: [
          if (onRefresh != null)
            SliverPadding(
              padding: topPadding,
              sliver: CupertinoSliverRefreshControl(
                onRefresh: onRefresh,
                refreshIndicatorExtent: 72,
                refreshTriggerPullDistance: 120,
              ),
            ),
          if (!isLoading && itemCount == 0)
            SliverFillRemaining(
              child: Center(
                child: Container(
                  padding: onRefresh == null ? padding : bottomPadding,
                  child: emptyDataView,
                ),
              ),
            )
          else
            SliverPadding(
              padding: onRefresh == null ? padding : bottomPadding,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (!hasSeparator) {
                      if (index >= itemCount) {
                        return loadingItemBuilder(context, index);
                      } else {
                        return itemBuilder(context, index);
                      }
                    } else {
                      var initialIndex = index ~/ 2;
                      if (index.isOdd) {
                        return separatorBuilder?.call(context, initialIndex);
                      } else {
                        if (initialIndex >= itemCount) {
                          return loadingItemBuilder(context, initialIndex);
                        } else {
                          return itemBuilder(context, initialIndex);
                        }
                      }
                    }
                  },
                  childCount: childCount,
                  semanticIndexCallback: (widget, index) => hasSeparator ? index ~/ 2 : index,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
