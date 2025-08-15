part of 'login_view.dart';

class LoginCubit extends BaseCubit<LoginState> {
  LoginCubit(BuildContext context) : super(context, LoginState.initialState) {
    Timer(const Duration(seconds: 3), showLoginView);
  }

  void showLoginView() {
  //  emit(state.copyWith(isShowLoginView: true));
  }

  void onForgotTap() {
    Navigator.of(context).pushNamed(ForgotPasswordView.routeName);
  }

  void onCountrySelect(Country? value) {
    Log.debug("value..${value?.phoneCode}");
    if (value == null) return;
    emit(state.copyWith(country: value, showEmailOrPhoneNumber: true));
  }

  Future<void> onChangeMobile(String mob) async {
    if (state.isOtpFieldVisible) {
      emit(state.copyWith(
        isOtpFieldVisible: false,
        otpSentMessage: "",
      ));
    }
  }

  Future<void> onSignInTap() async {
    if (state.formKey.currentState!.validate()) {
      SystemChannels.textInput.invokeMethod<void>('TextInput.hide');

      if (!state.isOtpFieldVisible) {
        context.hideKeyboard();
        try {
          var response = await processApi(
            () => apiClient.sendOtp(0, "", "", state.mobileController.text),
            doShowLoader: true,
          );
          if (response?.data != null) {
            emit(state.copyWith(
                isOtpFieldVisible: true, otpSentMessage: response?.message ?? "", otp: response?.data.otp.toString()));
          }
        } catch (error) {
          if (error is ApiException) {
            onRegisterTap();
          }
        }
      } else {
        if (state.otpController.text.isEmpty) {
          showErrors(S.current.errorOtpEmpty);
        } else if (state.otpController.text.length < 6) {
          showErrors(S.current.errorOtpInvalid);
        } else if (state.otp != state.otpController.text.toString()) {
          showErrors(S.current.errorOtpDoesNotMatch);
        } else {
          var response = await processApi(() => apiClient.login(mobile: state.mobileController.text), doShowLoader: true);
          Log.debug("response..$response");
          response?.data.let((it) {
            AppPref.userToken = it.token;
            AppPref.user = it;
            AppPref.isLogin = true;
            eventBus.fire("user_login");
            Navigator.of(context).pushNamedAndRemoveUntil(MainView.routeName, (_) => false);
          });
        }
      }
    }
  }

  void onRegisterTap() {
    SystemChannels.textInput.invokeMethod<void>('TextInput.hide');

    Navigator.of(context).pushNamed(CreateAccountView.routeName);
  }

  void continueAsGuest() {
    SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
    AppPref.isGuestUser = true;
    Navigator.of(context).pushNamedAndRemoveUntil(SplashView.routeName, (_) => false);
  }
}
