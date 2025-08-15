part of 'change_password_view.dart';

class ChangePasswordState extends Equatable {
  final GlobalKey<FormState> formKey;
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final bool showOldPassword;
  final bool showNewPassword;
  final bool showConfirmPassword;

  const ChangePasswordState(
    this.formKey,
    this.oldPasswordController,
    this.newPasswordController,
    this.confirmPasswordController, {
    this.showOldPassword = false,
    this.showNewPassword = false,
    this.showConfirmPassword = false,
  });

  @override
  List<Object?> get props => [showOldPassword, showNewPassword, showConfirmPassword];

  ChangePasswordState copyWith({
    bool? showOldPassword,
    bool? showNewPassword,
    bool? showConfirmPassword,
  }) {
    return ChangePasswordState(
      formKey,
      oldPasswordController,
      newPasswordController,
      confirmPasswordController,
      showOldPassword: showOldPassword ?? this.showOldPassword,
      showNewPassword: showNewPassword ?? this.showNewPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
    );
  }
}
