part of 'contact_us_view.dart';

class ContactUsCubit extends BaseCubit<ContactUsState> {


  ContactUsCubit(BuildContext context, ContactUsState initialState) : super(context, initialState) {
    Timer.run(() {
      _getCategories();
    });
  }



  Future<void> onRefresh() async {
    if (state.isLoading) return;
    emit(state.copyWith(list: []));
    return _getCategories();
  }

  Future<void> _getCategories() async {
    emit(state.copyWith(isLoading: true));
    var response = await processApi(() => apiClient.getFaqs());
    emit(state.copyWith(list: response?.data, isLoading: false));
  }


}
