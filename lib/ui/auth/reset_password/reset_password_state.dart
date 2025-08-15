part of 'reset_password_view.dart';

class ResetPasswordState extends Equatable {
  final GlobalKey<FormState> formKey;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool showNewPassword;
  final bool showConfirmPassword;

  const ResetPasswordState(
    this.formKey,
    this.newPasswordController,
    this.confirmPasswordController, {
    this.showNewPassword = false,
    this.showConfirmPassword = false,
  });

  @override
  List<Object?> get props => [showNewPassword, showConfirmPassword];

  ResetPasswordState copyWith({
    bool? showNewPassword,
    bool? showConfirmPassword,
  }) {
    return ResetPasswordState(
      formKey,
      newPasswordController,
      confirmPasswordController,
      showNewPassword: showNewPassword ?? this.showNewPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
    );
  }
}
