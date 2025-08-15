part of 'pricing_view.dart';

class PricingState extends Equatable {
  final List<SubscriptionPlan> list;
  final bool isLoading;
  final bool isShowAppBar;


  const PricingState({this.list = const [], this.isLoading = false,    this.isShowAppBar = false,
  });

  @override
  List<Object?> get props => [list, isLoading,isShowAppBar];

  PricingState copyWith({
    List<SubscriptionPlan>? list,
    bool? isLoading,
    bool? isShowAppBar,

  }) {
    return PricingState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,      isShowAppBar: isShowAppBar ?? this.isShowAppBar,

    );
  }
}
