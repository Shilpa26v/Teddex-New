part of 'verification_view.dart';

class VerificationCubit extends BaseCubit<VerificationState> {
  VerificationCubit(BuildContext context, VerificationState initialState) : super(context, initialState);

  void clearError() {
    emit(state.copyWith(isValid: true, error: ""));
  }

  Future<void> onResendTap() async {
    context.hideKeyboard();
  }

  Future<void> onVerifyTap() async {
    context.hideKeyboard();
    if (validate()) {
      if (state.type == "register") {
        Navigator.of(context).popUntil(ModalRoute.withName(MainView.routeName));
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          ResetPasswordView.routeName,
          ModalRoute.withName(LoginView.routeName),
        );
      }
    }
  }

  bool validate() {
    if (state.otpController.text.isEmpty) {
      emit(state.copyWith(isValid: false, error: S.current.errorOtpEmpty));
      return false;
    } else if (state.otpController.text.length < 6) {
      emit(state.copyWith(isValid: false, error: S.current.errorOtpInvalid));
      return false;
    } else {
      emit(state.copyWith(isValid: true, error: ""));
      return true;
    }
  }
}
