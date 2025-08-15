import 'package:equatable/equatable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';
import 'package:pinput/pinput.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/auth/login/login_view.dart';
import 'package:teddex/ui/auth/reset_password/reset_password_view.dart';
import 'package:teddex/ui/common/registration_header_view.dart';
import 'package:teddex/ui/main/main_view.dart';
import 'package:teddex/widgets/widgets.dart';

part 'verification_cubit.dart';
part 'verification_state.dart';

class VerificationViewArguments {
  final String type;
  final String mobile;
  final String countryCode;
  final String email;

  const VerificationViewArguments({
    required this.type,
    this.mobile = "",
    this.countryCode = "",
    this.email = "",
  });
}

class VerificationView extends StatefulWidget {
  const VerificationView({Key? key}) : super(key: key);

  static const routeName = "/verification_view";

  static Widget builder(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null && args is VerificationViewArguments);
    var argument = args as VerificationViewArguments;
    final state = VerificationState(
      TextEditingController(),
      argument.type,
      mobileNumber: argument.mobile,
      countryCode: argument.countryCode,
      email: argument.email,
    );
    return BlocProvider(
      create: (context) => VerificationCubit(context, state),
      child: const VerificationView(),
    );
  }

  @override
  _VerificationViewState createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  @override
  Widget build(BuildContext context) {
    var initialState = BlocProvider.of<VerificationCubit>(context).state;
    return Scaffold(
      appBar: AppBar(
        leading: const BackIcon(),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(20, 24, 20, 24 + context.mediaQueryPadding.bottom),
        clipBehavior: Clip.none,
        child: Column(
          children: [
            if (initialState.type == "register")
              RegistrationHeaderView(
                title: S.of(context).verificationTitle,
                subTitle: S.of(context).verificationSubTitlePhone(initialState.countryCode, initialState.mobileNumber),
              )
            else
              RegistrationHeaderView(
                title: S.of(context).verificationTitle,
                subTitle: S.of(context).verificationSubTitleEmail(initialState.email),
              ),
            BlocBuilder<VerificationCubit, VerificationState>(
              buildWhen: (previous, current) => previous.isValid != current.isValid,
              builder: (context, state) {
                return Pinput(
                  keyboardAppearance: Brightness.dark,
                  keyboardType: TextInputType.number,
                  controller: state.otpController,
                  autofocus: true,
                  /*textStyle: const TextStyle(
                    color: AppColor.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontFamily: kFontFamily,
                  ),
                  eachFieldWidth: 56,
                  eachFieldHeight: 56,
                  autovalidateMode: AutovalidateMode.always,
                  fieldsCount: 6,
                  selectedFieldDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.theme.primaryColor, width: 2),
                  ),
                  submittedFieldDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.green, width: 2),
                  ),
                  followingFieldDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.greyLight, width: 2),
                  ),
                  textInputAction: TextInputAction.done,
                  inputDecoration: const InputDecoration(
                    border: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    counter: SizedBox.shrink(),
                    filled: false,
                  ),*/
                  pinAnimationType: PinAnimationType.scale,
                );
              },
            ),
            BlocBuilder<VerificationCubit, VerificationState>(
              buildWhen: (previous, current) => previous.isValid != current.isValid || previous.error != current.error,
              builder: (context, state) {
                if (state.isValid) {
                  return const Gap(24);
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: CommonText.medium(
                      state.error,
                      size: 14,
                      color: context.theme.colorScheme.error,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              },
            ),
            Text.rich(
              TextSpan(
                text: S.of(context).didntReceivedCode + " ",
                style: const TextStyle(color: AppColor.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
                children: [
                  TextSpan(
                    text: S.of(context).resendCode,
                    style: const TextStyle(color: AppColor.primary, fontSize: 14, fontWeight: FontWeight.w500),
                    recognizer: TapGestureRecognizer()..onTap = BlocProvider.of<VerificationCubit>(context).onResendTap,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: IntrinsicHeight(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8 + context.bottomInset),
            child: CommonButton(
              onPressed: BlocProvider.of<VerificationCubit>(context).onVerifyTap,
              label: S.of(context).btnVerify,
            ),
          ),
        ),
      ),
    );
  }
}
