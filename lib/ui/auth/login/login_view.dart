import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/helpers/src/validator.dart';
import 'package:teddex/pref/app_pref.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/auth/create_account/create_account_view.dart';
import 'package:teddex/ui/auth/forgot_password/forgot_password_view.dart';
import 'package:teddex/ui/main/main_view.dart';
import 'package:teddex/ui/splash/splash_view.dart';
import 'package:teddex/widgets/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';

part 'login_cubit.dart';

part 'login_state.dart';

class LoginViewArguments {
  final bool isAllowBack;

  const LoginViewArguments({this.isAllowBack = false});
}

class LoginView extends StatefulWidget {
  static bool isAllowBack = false;

  const LoginView({Key? key}) : super(key: key);

  static const routeName = "/login_view";

  static Widget builder(BuildContext context) {
    if (context.args != null) {
      isAllowBack = (context.args as LoginViewArguments).isAllowBack;
    }
    return BlocProvider(
      create: (context) => LoginCubit(context),
      child: const LoginView(),
    );
  }

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    var initialState = BlocProvider.of<LoginCubit>(context).state;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.loginBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: LoginView.isAllowBack
            ? AppBar(leading: const BackIcon(), elevation: 0)
            : null,
        backgroundColor: AppColor.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: context.height / 4,
              width: double.infinity,
            ),
            Expanded(
              child: BlocSelector<LoginCubit, LoginState, bool>(
                selector: (state) => state.isShowLoginView,
                builder: (context, isShowLoginView) {
                  return isShowLoginView
                      ? Card(
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.zero,
                              bottomRight: Radius.zero,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 22),
                                  child: SingleChildScrollView(
                                    child: Form(
                                      key: initialState.formKey,
                                      child: Column(
                                        children: [
                                          const Gap(22),
                                          Align(
                                              alignment: Alignment.center,
                                              child: CommonText.regular(
                                                  S.current.loginSubTitle,
                                                  size: 24)),
                                          const Gap(12),
                                          Align(
                                              alignment: Alignment.center,
                                              child: CommonText.regular(
                                                S.current.welcome_note,
                                                size: 12,
                                                textAlign: TextAlign.center,
                                              )),
                                          const Gap(28),
                                          CommonTextField(
                                              controller:
                                                  initialState.mobileController,
                                              labelText:
                                                  S.of(context).labelMobile,
                                              hintText:
                                                  S.of(context).labelMobile,
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged:
                                                  BlocProvider.of<LoginCubit>(
                                                          context)
                                                      .onChangeMobile,
                                              validator: validateMobileNumber),
                                          const Gap(22),
                                          BlocSelector<LoginCubit, LoginState,
                                              bool>(
                                            selector: (state) =>
                                                state.isOtpFieldVisible,
                                            builder:
                                                (context, isOtpFieldVisible) {
                                              return isOtpFieldVisible
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        CommonTextField(
                                                            controller:
                                                                initialState
                                                                    .otpController,
                                                            labelText: S
                                                                .of(context)
                                                                .labelVerificationCode,
                                                            hintText: S
                                                                .of(context)
                                                                .labelVerificationCode,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            validator:
                                                                validateOtp,
                                                            maxLength: 6),
                                                        BlocSelector<LoginCubit,
                                                            LoginState, String>(
                                                          selector: (state) =>
                                                              state
                                                                  .otpSentMessage,
                                                          builder: (context,
                                                              otpSentMessage) {
                                                            return Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 8),
                                                                child:
                                                                    CommonText
                                                                        .medium(
                                                                  otpSentMessage,
                                                                  color:
                                                                      AppColor
                                                                          .red,
                                                                  size: 12,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      ],
                                                    )
                                                  : const SizedBox.shrink();
                                            },
                                          ),
                                          const Gap(28),
                                          BlocSelector<LoginCubit, LoginState,
                                              bool>(
                                            selector: (state) =>
                                                state.isOtpFieldVisible,
                                            builder:
                                                (context, isOtpFieldVisible) {
                                              return CommonButton(
                                                onPressed:
                                                    BlocProvider.of<LoginCubit>(
                                                            context)
                                                        .onSignInTap,
                                                label: !isOtpFieldVisible
                                                    ? S.of(context).btnSendOtp
                                                    : S.of(context).btnContinue,
                                              );
                                            },
                                          ),
                                          const Gap(12),
                                          ElevatedButton(
                                            onPressed:
                                                BlocProvider.of<LoginCubit>(
                                                        context)
                                                    .continueAsGuest,
                                            clipBehavior: Clip.hardEdge,
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColor.greyLight),
                                            child: Center(
                                              child: CommonText.bold(
                                                S
                                                    .of(context)
                                                    .btnContinueAsGuest,
                                                size: 16,
                                                color: context
                                                    .theme.colorScheme.primary,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                                  .viewPadding
                                                  .bottom >
                                              0
                                          ? MediaQuery.of(context)
                                              .viewPadding
                                              .bottom
                                          : 12),
                                  child: SizedBox(
                                    height: 52,
                                    child: Center(
                                      child: Text.rich(
                                        TextSpan(
                                          text:
                                              "${S.of(context).dontHaveAccount} ",
                                          style: const TextStyle(
                                              color: AppColor.textPrimary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                          children: [
                                            TextSpan(
                                              text: S.of(context).registerHere,
                                              style: const TextStyle(
                                                  color: AppColor.yellow,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap =
                                                    BlocProvider.of<LoginCubit>(
                                                            context)
                                                        .onRegisterTap,
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        /* body: SingleChildScrollView+
       (
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          clipBehavior: Clip.none,
          child: Form(
            key: initialState.formKey,
            child: Column(
              children: [
                RegistrationHeaderView(
                  title: S.of(context).loginTitle,
                  subTitle: S.of(context).loginSubTitle,
                ),
                const Gap(22),
                CommonTextField(
                    controller: initialState.mobileController,
                    labelText: S.of(context).labelMobile,
                    hintText: S.of(context).labelMobile,
                    keyboardType: TextInputType.number,
                    onChanged: BlocProvider.of<LoginCubit>(context).onChangeMobile,
                    validator: validateMobileNumber),
                const Gap(22),
                BlocSelector<LoginCubit, LoginState, bool>(
                  selector: (state) => state.isOtpFieldVisible,
                  builder: (context, isOtpFieldVisible) {
                    return isOtpFieldVisible
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CommonTextField(
                                  controller: initialState.otpController,
                                  labelText: S.of(context).labelVerificationCode,
                                  hintText: S.of(context).labelVerificationCode,
                                  keyboardType: TextInputType.number,
                                  validator: validateOtp,
                                  maxLength: 6),
                              BlocSelector<LoginCubit, LoginState, String>(
                                selector: (state) => state.otpSentMessage,
                                builder: (context, otpSentMessage) {
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: CommonText.medium(
                                        otpSentMessage,
                                        color: AppColor.red,
                                        size: 12,
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          )
                        : const SizedBox.shrink();
                  },
                ),
                const Gap(28),
                BlocSelector<LoginCubit, LoginState, bool>(
                  selector: (state) => state.isOtpFieldVisible,
                  builder: (context, isOtpFieldVisible) {
                    return CommonButton(
                      onPressed: BlocProvider.of<LoginCubit>(context).onSignInTap,
                      label: !isOtpFieldVisible ? S.of(context).btnSendOtp : S.of(context).btnContinue,
                    );
                  },
                ),
                const Gap(12),
                ElevatedButton(
                  onPressed: BlocProvider.of<LoginCubit>(context).continueAsGuest,
                  clipBehavior: Clip.hardEdge,
                  style: ElevatedButton.styleFrom(primary: AppColor.greyLight),
                  child: Center(
                    child: CommonText.bold(
                      S.of(context).btnContinueAsGuest,
                      size: 16,
                      color: context.theme.colorScheme.primary,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: context.theme.scaffoldBackgroundColor,
          elevation: 0,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            height: 56,
            child: Center(
              child: Text.rich(
                TextSpan(
                  text: "${S.of(context).dontHaveAccount} ",
                  style: const TextStyle(color: AppColor.textPrimary, fontSize: 16, fontWeight: FontWeight.w500),
                  children: [
                    TextSpan(
                      text: S.of(context).registerHere,
                      style: const TextStyle(color: AppColor.yellow, fontSize: 16, fontWeight: FontWeight.w500),
                      recognizer: TapGestureRecognizer()..onTap = BlocProvider.of<LoginCubit>(context).onRegisterTap,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),*/
      ),
    );
  }
}
