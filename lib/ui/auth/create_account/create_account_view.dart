import 'package:country_picker/country_picker.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/helpers/src/validator.dart';
import 'package:teddex/pref/app_pref.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/common/registration_header_view.dart';
import 'package:teddex/ui/main/main_view.dart';
import 'package:teddex/widgets/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';

part 'create_account_cubit.dart';

part 'create_account_state.dart';

class CreateAccountArguments {
  final String? email;

  const CreateAccountArguments({this.email});
}

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({Key? key}) : super(key: key);

  static const routeName = "/create_account_view";

  static Widget builder(BuildContext context) {
    var args = context.args;
    String? email;
    if (args is CreateAccountArguments) {
      email = args.email;
    }
    final state = CreateAccountState(
      GlobalKey<FormState>(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(text: email),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      true,
      country: CountryPickerUtils.getCountryByPhoneCode("91"),
    );
    return BlocProvider(
      create: (context) => CreateAccountCubit(context, state),
      child: const CreateAccountView(),
    );
  }

  @override
  _CreateAccountViewState createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  @override
  Widget build(BuildContext context) {
    var initialState = BlocProvider.of<CreateAccountCubit>(context).state;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.createAccBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: AppColor.transparent,
          appBar: AppBar(
            leading: const BackIcon(),
            elevation: 0,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: context.height/4,
                width: double.infinity,
              ),
              Expanded(
                child: Card(
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                    child: SingleChildScrollView(
                      child: Form(
                        key: initialState.formKey,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RegistrationHeaderView(
                                title: S.of(context).registerTitle,
                                subTitle:"",
                              ),
                            ),
                            CommonTextField(
                              controller: initialState.nameController,
                              labelText: S.of(context).labelName,
                              hintText: S.of(context).hintName,
                              keyboardType: TextInputType.name,
                              validator: (value) => value.isNullOrEmpty ? S.current.errorNameEmpty : null,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Builder(builder: (context) {
                                  return SquareSvgImageFromAsset(AppImages.imagesProfile,
                                      size: 20, color: IconTheme.of(context).color);
                                }),
                              ),
                            ),
                            const Gap(16),
                            BlocSelector<CreateAccountCubit, CreateAccountState, Country?>(
                                selector: (state) => state.country,
                                builder: (context, country) {
                                  return Column(
                                    children: [
                                      CommonTextField(
                                        controller: initialState.phoneController,
                                        labelText: S.of(context).labelPhone,
                                        hintText: S.of(context).hintPhone,
                                        keyboardType: TextInputType.phone,
                                        validator:
                                        country?.phoneCode == "91" ? validateINDMobileNumber : validateMobileNumber,
                                        inputFormatters: [NumberInputFormatter(length: 10)],
                                        prefixIcon: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Builder(builder: (context) {
                                                return SquareSvgImageFromAsset(AppImages.imagesPhone,
                                                    size: 20, color: IconTheme.of(context).color);
                                              }),
                                            ),
                                            BlocBuilder<CreateAccountCubit, CreateAccountState>(
                                              buildWhen: (previous, current) => previous.country != current.country,
                                              builder: (context, state) {
                                                return CountryCodePicker(
                                                  selectedCountry: state.country,
                                                  onSelectedCountryChanged:
                                                  BlocProvider.of<CreateAccountCubit>(context).onSelectedCountryChanged,
                                                );
                                              },
                                            ),
                                            const SizedBox(height: 16, child: VerticalDivider(color: AppColor.grey)),
                                            const Gap(8),
                                          ],
                                        ),
                                      ),
                                      BlocSelector<CreateAccountCubit, CreateAccountState, String>(
                                        selector: (state) => state.otpSentMobileMessage,
                                        builder: (context, otpSentMessage) {
                                          return otpSentMessage.isNotEmpty
                                              ? Align(
                                            alignment: Alignment.centerLeft,
                                            child: CommonText.medium(
                                              otpSentMessage,
                                              color: AppColor.red,
                                              size: 12,
                                            ),
                                          )
                                              : const SizedBox.shrink();
                                        },
                                      )
                                    ],
                                  );
                                }),
                            const Gap(16),
                            BlocSelector<CreateAccountCubit, CreateAccountState, Country?>(
                                selector: (state) => state.country,
                                builder: (context, country) {
                                  return country?.phoneCode != "91"
                                      ? Column(
                                    children: [
                                      CommonTextField(
                                        controller: initialState.emailController,
                                        labelText: S.of(context).labelEmail,
                                        hintText: S.of(context).hintEmail,
                                        keyboardType: TextInputType.emailAddress,
                                        validator: validateEmail,
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Builder(builder: (context) {
                                            return SquareSvgImageFromAsset(AppImages.imagesEmail,
                                                size: 20, color: IconTheme.of(context).color);
                                          }),
                                        ),
                                      ),
                                      BlocSelector<CreateAccountCubit, CreateAccountState, String>(
                                        selector: (state) => state.otpSentEmailMessage,
                                        builder: (context, otpSentMessage) {
                                          return otpSentMessage.isNotEmpty
                                              ? Align(
                                            alignment: Alignment.centerLeft,
                                            child: CommonText.medium(
                                              otpSentMessage,
                                              color: AppColor.red,
                                              size: 12,
                                            ),
                                          )
                                              : const SizedBox.shrink();
                                        },
                                      )
                                    ],
                                  )
                                      : const SizedBox.shrink();
                                }),
                            const Gap(16),
                            BlocSelector<CreateAccountCubit, CreateAccountState, bool>(
                              selector: (state) => state.isOtpFieldVisible,
                              builder: (context, isOtpFieldVisible) {
                                return isOtpFieldVisible
                                    ? CommonTextField(
                                    controller: initialState.otpCtrl,
                                    labelText: S.of(context).labelVerificationCode,
                                    hintText: S.of(context).labelVerificationCode,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    validator: validateOtp,
                                    maxLength: 6)
                                    : const SizedBox.shrink();
                              },
                            ),
                            const Gap(16),
                            BlocSelector<CreateAccountCubit, CreateAccountState, bool>(
                                selector: (state) => state.isOtpFieldVisible,
                                builder: (context, isOtpFieldVisible) {
                                  return CommonButton(
                                    onPressed: BlocProvider.of<CreateAccountCubit>(context).onSignUpTap,
                                    label: !isOtpFieldVisible ? S.of(context).btnSendOtp : S.of(context).btnSignUp,
                                  );
                                }),
                            const Gap(16),
                            if(MediaQuery.of(context).viewPadding.bottom>0)
                            Gap(MediaQuery.of(context).viewPadding.bottom )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newString = newValue.text.replaceAll(',', '.');
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}
