import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/helpers/src/validator.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/common/registration_header_view.dart';
import 'package:teddex/widgets/widgets.dart';

part 'forgot_password_cubit.dart';
part 'forgot_password_state.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  static const routeName = "/forgot_password_view";

  static Widget builder(BuildContext context) {
    final state = ForgotPasswordState(GlobalKey<FormState>(), TextEditingController());
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(context, state),
      child: const ForgotPasswordView(),
    );
  }

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  @override
  Widget build(BuildContext context) {
    var initialState = BlocProvider.of<ForgotPasswordCubit>(context).state;
    return Scaffold(
      appBar: AppBar(
        leading: const BackIcon(),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        clipBehavior: Clip.none,
        child: Form(
          key: initialState.formKey,
          child: Column(
            children: [
              RegistrationHeaderView(
                title: S.of(context).forgotPasswordTitle,
                subTitle: S.of(context).forgotPasswordSubTitle,
              ),
              CommonTextField(
                controller: initialState.emailController,
                labelText: S.of(context).labelEmail,
                hintText: S.of(context).hintEmail,
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Builder(builder: (context) {
                    return SquareSvgImageFromAsset(AppImages.imagesEmail, size: 20, color: IconTheme.of(context).color);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: IntrinsicHeight(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8 + context.bottomInset),
            child: CommonButton(
              onPressed: BlocProvider.of<ForgotPasswordCubit>(context).onSendCode,
              label: S.of(context).btnSendCode,
            ),
          ),
        ),
      ),
    );
  }
}
