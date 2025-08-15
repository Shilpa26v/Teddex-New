part of 'login_view.dart';

class LoginState extends Equatable {
  final GlobalKey<FormState> formKey;
  final TextEditingController mobileController;
  final TextEditingController otpController;
  final Country? country;
  final bool isVerified;
  final bool isOtpFieldVisible;
  final bool isShowLoginView;
  final String otpSentMessage;
  final String otp;

  const LoginState(
    this.formKey,
    this.mobileController,this.otpController, {
    this.country,
    this.isVerified = false,
    this.isOtpFieldVisible = false,
    this.isShowLoginView = true,
    this.otpSentMessage="",
    this.otp="",
  });

  @override
  List<Object?> get props => [ country,isVerified,isOtpFieldVisible,otpSentMessage,otp,isShowLoginView];

  static LoginState get initialState => LoginState(
        GlobalKey<FormState>(),
        TextEditingController(),
        TextEditingController(),
      );

  LoginState copyWith({
    GlobalKey<FormState>? formKey,
    TextEditingController? mobileController,
    TextEditingController? passwordController,
    TextEditingController? otpController,
    Country? country,
    bool? showEmailOrPhoneNumber,
    int? initCountryCode,
    bool? isVerified,
    bool? isShowLoginView,
    bool? isOtpFieldVisible,
    String? otpSentMessage,
    String? otp,
  }) {
    return LoginState(
      this.formKey,
      this.mobileController,
      this.otpController,
      country: country ?? this.country,
      isVerified: isVerified ?? this.isVerified,
      isShowLoginView: isShowLoginView ?? this.isShowLoginView,
      isOtpFieldVisible: isOtpFieldVisible ?? this.isOtpFieldVisible,
      otpSentMessage: otpSentMessage ?? this.otpSentMessage,
      otp: otp ?? this.otp,
    );
  }
}
