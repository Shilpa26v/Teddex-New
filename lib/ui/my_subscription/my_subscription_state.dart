part of 'my_subscription_view.dart';

class MySubscriptionState extends Equatable {
  final List<MyPlan>? plan;
  final bool isLoading;

  const MySubscriptionState({
    this.plan,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [plan, isLoading];

  MySubscriptionState copyWith({
    List<MyPlan>? plan,
    bool? isLoading,
  }) {
    return MySubscriptionState(
      plan: plan ?? this.plan,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
