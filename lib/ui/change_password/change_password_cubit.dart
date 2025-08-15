part of 'change_password_view.dart';

class ChangePasswordCubit extends BaseCubit<ChangePasswordState> {
  ChangePasswordCubit(BuildContext context, ChangePasswordState initialState) : super(context, initialState);

  void toggleOldPassword() {
    emit(state.copyWith(showOldPassword: !state.showOldPassword));
  }

  void toggleNewPassword() {
    emit(state.copyWith(showNewPassword: !state.showNewPassword));
  }

  void toggleConfirmPassword() {
    emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
  }

  Future<void> changePassword() async {
    context.hideKeyboard();
    if (state.formKey.currentState!.validate()) {
      var response = await processApi(
        () => apiClient.changePassword(state.newPasswordController.text),
        doShowLoader: true,
      );
      if (response?.data != null) {
        Navigator.of(context).pop();
      }
    }
  }
}
