part of 'create_account_view.dart';

class CreateAccountState extends Equatable {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController otpCtrl;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController machineTypeController;
  final TextEditingController mobileController;
  final TextEditingController otpController;
  final Country country;
  final bool isSocialRegister;
  final bool isEmailEditable;
  final bool isShowEmailOrNumber;
  final bool showConfirmPassword;
  final bool isVerified;
  final bool isOtpFieldVisible;
  final String otpSentMobileMessage;
  final String otpSentEmailMessage;
  final String otp;
  final bool isShowRegisterView;

  const CreateAccountState(
    this.formKey,
    this.nameController,
    this.otpCtrl,
    this.phoneController,
    this.emailController,
    this.machineTypeController,
    this.otpController,
    this.mobileController,
    this.isEmailEditable, {
    required this.country,
    this.isSocialRegister = false,
    this.isShowEmailOrNumber = false,
    this.showConfirmPassword = false,
    this.isVerified = false,
    this.isShowRegisterView = false,
    this.isOtpFieldVisible = false,
    this.otpSentMobileMessage = "",
    this.otpSentEmailMessage = "",
    this.otp = "",
  });

  @override
  List<Object?> get props => [
        country,
        isSocialRegister,
        isShowEmailOrNumber,
        showConfirmPassword,
        isVerified,
        isOtpFieldVisible,
        otpSentEmailMessage,
        otpSentMobileMessage,
        isShowRegisterView,
        otp
      ];

  CreateAccountState copyWith({
    Country? country,
    bool? isSocialRegister,
    bool? isShowEmailOrNumber,
    bool? showConfirmPassword,
    bool? isVerified,
    bool? isOtpFieldVisible,
    String? otpSentEmailMessage,
    String? otpSentMobileMessage,
    bool? isShowRegisterView,
    String? otp,
  }) {
    return CreateAccountState(
      formKey,
      nameController,
      otpCtrl,
      phoneController,
      emailController,
      machineTypeController,
      mobileController,
      otpController,
      isEmailEditable,
      country: country ?? this.country,
      isSocialRegister: isSocialRegister ?? this.isSocialRegister,
      isShowEmailOrNumber: isShowEmailOrNumber ?? this.isShowEmailOrNumber,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      isVerified: isVerified ?? this.isVerified,
      isOtpFieldVisible: isOtpFieldVisible ?? this.isOtpFieldVisible,
      otpSentEmailMessage: otpSentEmailMessage ?? this.otpSentEmailMessage,
      otpSentMobileMessage: otpSentMobileMessage ?? this.otpSentMobileMessage,
      isShowRegisterView: isShowRegisterView ?? this.isShowRegisterView,
      otp: otp ?? this.otp,
    );
  }
}
