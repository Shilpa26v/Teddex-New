part of 'my_subscription_view.dart';

class MySubscriptionCubit extends BaseCubit<MySubscriptionState> {
  MySubscriptionCubit(BuildContext context, MySubscriptionState initialState) : super(context, initialState) {
    Timer.run(_getMyPlan);
  }

  Future<void> _getMyPlan() async {
    emit(state.copyWith(isLoading: true));
    var response = await processApi(() => apiClient.getMyPlan());
    if(response?.data!=null && response!.data.isNotEmpty) {
      emit(state.copyWith(plan: response.data, isLoading: false));
    }
  }
}
