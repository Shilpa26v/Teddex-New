import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/helpers/src/validator.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/common/registration_header_view.dart';
import 'package:teddex/widgets/widgets.dart';

part 'reset_password_cubit.dart';
part 'reset_password_state.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  static const routeName = "/reset_password_view";

  static Widget builder(BuildContext context) {
    final state = ResetPasswordState(
      GlobalKey<FormState>(),
      TextEditingController(),
      TextEditingController(),
    );
    return BlocProvider(
      create: (context) => ResetPasswordCubit(context, state),
      child: const ResetPasswordView(),
    );
  }

  @override
  _ResetPasswordViewState createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  @override
  Widget build(BuildContext context) {
    var initialState = BlocProvider.of<ResetPasswordCubit>(context).state;
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
                title: S.of(context).resetPasswordTitle,
                subTitle: S.of(context).resetPasswordSubTitle,
              ),
              BlocSelector<ResetPasswordCubit, ResetPasswordState, bool>(
                selector: (state) => state.showNewPassword,
                builder: (context, showNewPassword) => CommonTextField(
                  controller: initialState.newPasswordController,
                  hintText: S.of(context).hintNewPassword,
                  labelText: S.of(context).labelNewPassword,
                  keyboardType: TextInputType.visiblePassword,
                  obscure: !showNewPassword,
                  validator: validatePassword,
                  suffixIcon: IconButton(
                    splashRadius: 20,
                    onPressed: BlocProvider.of<ResetPasswordCubit>(context).toggleNewPassword,
                    icon: SquareSvgImageFromAsset(
                      showNewPassword ? AppImages.imagesPasswordVisible : AppImages.imagesPasswordInvisible,
                      size: 20,
                    ),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Builder(builder: (context) {
                      return SquareSvgImageFromAsset(AppImages.imagesPassword,
                          size: 20, color: IconTheme.of(context).color);
                    }),
                  ),
                ),
              ),
              const Gap(16),
              BlocSelector<ResetPasswordCubit, ResetPasswordState, bool>(
                selector: (state) => state.showConfirmPassword,
                builder: (context, showConfirmPassword) => CommonTextField(
                  controller: initialState.confirmPasswordController,
                  hintText: S.of(context).hintConfirmPassword,
                  labelText: S.of(context).labelConfirmPassword,
                  keyboardType: TextInputType.visiblePassword,
                  obscure: !showConfirmPassword,
                  validator: (value) => validateConfirmPassword(value, initialState.newPasswordController.text),
                  suffixIcon: IconButton(
                    splashRadius: 20,
                    onPressed: BlocProvider.of<ResetPasswordCubit>(context).toggleConfirmPassword,
                    icon: SquareSvgImageFromAsset(
                      showConfirmPassword ? AppImages.imagesPasswordVisible : AppImages.imagesPasswordInvisible,
                      size: 20,
                    ),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Builder(builder: (context) {
                      return SquareSvgImageFromAsset(AppImages.imagesPassword,
                          size: 20, color: IconTheme.of(context).color);
                    }),
                  ),
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
              onPressed: BlocProvider.of<ResetPasswordCubit>(context).savePassword,
              label: S.of(context).btnSavePassword,
            ),
          ),
        ),
      ),
    );
  }
}
