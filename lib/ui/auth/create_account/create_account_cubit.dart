part of 'create_account_view.dart';

class CreateAccountCubit extends BaseCubit<CreateAccountState> {
  CreateAccountCubit(BuildContext context, CreateAccountState initialState) : super(context, initialState);

  void onCountrySelect(Country? value) {
    if (value == null) return;
    emit(state.copyWith(country: value, isShowEmailOrNumber: true));
  }

  void onSelectedCountryChanged(Country country) {
    emit(state.copyWith(country: country));
  }

  Future<void> onSignUpTap() async {
    context.hideKeyboard();
    if (state.formKey.currentState!.validate()) {
      if (!state.isOtpFieldVisible) {
        try {
          var response = await processApi(
              () => apiClient.sendOtp(1, state.country.phoneCode, state.emailController.text, state.phoneController.text),
              doShowLoader: true);
          if (response?.data != null) {
            emit(state.copyWith(
                isOtpFieldVisible: true,
                otpSentMobileMessage: state.country.phoneCode == "91" ? response?.message ?? "" : "",
                otpSentEmailMessage: state.country.phoneCode != "91" ? response?.message ?? "" : "",
                otp: response?.data.otp.toString()));
          }
        } catch (error) {
          if (error is ApiException) {
            showErrors(error.message);
          }
        }
      } else if (state.otp != state.otpCtrl.text.toString()) {
        showErrors(S.current.errorOtpDoesNotMatch);
      } else {
        var response = await processApi(
          () => apiClient.register(
              email: state.emailController.text,
              name: state.nameController.text,
              mobile: state.phoneController.text.replaceAll(" ", " "),
              countryCode: state.country.phoneCode),
          doShowLoader: true,
        );
        response?.data.let((it) {
          AppPref.userToken = it.token;
          AppPref.user = it;
          AppPref.isLogin = true;
          eventBus.fire("user_login");
          Navigator.of(context).pushNamedAndRemoveUntil(MainView.routeName, (_) => false);
        });
      }
    }else {
      Log.debug("not validating.");
    }
  }
}
