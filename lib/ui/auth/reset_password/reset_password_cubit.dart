part of 'reset_password_view.dart';

class ResetPasswordCubit extends BaseCubit<ResetPasswordState> {
  ResetPasswordCubit(BuildContext context, ResetPasswordState initialState) : super(context, initialState);

  void toggleNewPassword() {
    emit(state.copyWith(showNewPassword: !state.showNewPassword));
  }

  void toggleConfirmPassword() {
    emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
  }

  void savePassword() {
    context.hideKeyboard();
    if (state.formKey.currentState!.validate()) {
      Navigator.of(context).pop();
    }
  }
}
