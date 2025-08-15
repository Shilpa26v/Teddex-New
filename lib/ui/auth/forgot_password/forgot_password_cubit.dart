part of 'forgot_password_view.dart';

class ForgotPasswordCubit extends BaseCubit<ForgotPasswordState> {
  ForgotPasswordCubit(BuildContext context, ForgotPasswordState initialState) : super(context, initialState);

  Future<void> onSendCode() async {
    context.hideKeyboard();
    if (state.formKey.currentState!.validate()) {
      var response = await processApi(() => apiClient.forgotPassword(state.emailController.text), doShowLoader: true);
      if (response?.data != null) {
        showAppDialog(
          context: context,
          title: S.of(context).titleSuccess,
          content: S.of(context).forgotPasswordInstruction,
          positiveButton: AppDialogButton(
            label: S.of(context).btnOkay,
            onPressed: null,
          ),
        );
      }
    }
  }
}
