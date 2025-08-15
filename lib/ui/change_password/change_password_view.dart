import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/helpers/src/validator.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/widgets/widgets.dart';

part 'change_password_cubit.dart';
part 'change_password_state.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  static const routeName = "/change_password_view";

  static Widget builder(BuildContext context) {
    var state = ChangePasswordState(
      GlobalKey<FormState>(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    );
    return BlocProvider(
      create: (context) => ChangePasswordCubit(context, state),
      child: const ChangePasswordView(),
    );
  }

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  @override
  Widget build(BuildContext context) {
    final initialState = BlocProvider.of<ChangePasswordCubit>(context).state;
    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverAppBar(
            leading: const BackIcon(),
            title: Text(S.of(context).titleChangePassword),
            pinned: true,
            floating: false,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: initialState.formKey,
                child: Column(
                  children: [
                    /*BlocSelector<ChangePasswordCubit, ChangePasswordState, bool>(
                      selector: (state) => state.showOldPassword,
                      builder: (context, showOldPassword) => CommonTextField(
                        controller: initialState.oldPasswordController,
                        hintText: S.of(context).hintOldPassword,
                        labelText: S.of(context).labelOldPassword,
                        keyboardType: TextInputType.visiblePassword,
                        obscure: !showOldPassword,
                        validator: validateOldPassword,
                        suffixIcon: IconButton(
                          splashRadius: 20,
                          onPressed: BlocProvider.of<ChangePasswordCubit>(context).toggleOldPassword,
                          icon: SquareSvgImageFromAsset(
                            showOldPassword ? AppImages.imagesPasswordVisible : AppImages.imagesPasswordInvisible,
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
                    const Gap(16),*/
                    BlocSelector<ChangePasswordCubit, ChangePasswordState, bool>(
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
                          onPressed: BlocProvider.of<ChangePasswordCubit>(context).toggleNewPassword,
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
                    BlocSelector<ChangePasswordCubit, ChangePasswordState, bool>(
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
                          onPressed: BlocProvider.of<ChangePasswordCubit>(context).toggleConfirmPassword,
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
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: IntrinsicHeight(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8 + context.bottomInset),
            child: CommonButton(
              onPressed: BlocProvider.of<ChangePasswordCubit>(context).changePassword,
              label: S.of(context).btnChangePassword,
            ),
          ),
        ),
      ),
    );
  }
}
