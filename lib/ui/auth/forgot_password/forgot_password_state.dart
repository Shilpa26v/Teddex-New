part of 'forgot_password_view.dart';

class ForgotPasswordState extends Equatable {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;

  const ForgotPasswordState(
    this.formKey,
    this.emailController,
  );

  @override
  List<Object?> get props => [];
}
