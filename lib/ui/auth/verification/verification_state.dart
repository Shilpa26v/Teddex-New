part of 'verification_view.dart';

class VerificationState extends Equatable {
  final TextEditingController otpController;
  final String type;
  final String mobileNumber;
  final String countryCode;
  final String email;
  final bool isValid;
  final String error;

  const VerificationState(
    this.otpController,
    this.type, {
    this.mobileNumber = "",
    this.countryCode = "",
    this.email = "",
    this.isValid = true,
    this.error = "",
  });

  @override
  List<Object?> get props => [isValid, error];

  VerificationState copyWith({bool? isValid, String? error}) {
    return VerificationState(
      otpController,
      type,
      mobileNumber: mobileNumber,
      countryCode: countryCode,
      email: email,
      isValid: isValid ?? this.isValid,
      error: error ?? this.error,
    );
  }
}
