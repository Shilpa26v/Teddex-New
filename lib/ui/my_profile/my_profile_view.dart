import 'dart:async';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/pref/app_pref.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/widgets/widgets.dart';

part 'my_profile_cubit.dart';

part 'my_profile_state.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({Key? key}) : super(key: key);

  static const routeName = "/my_profile_view";

  static Widget builder(BuildContext context) {
    var user = AppPref.user!;
    var state = MyProfileState(
      GlobalKey<FormState>(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      country:CountryPickerUtils.getCountryByPhoneCode(user.countryCode!.isEmpty
          ? "91"
          : user.countryCode!.contains("+")
              ? user.countryCode!.replaceAll("+", "")
              : user.countryCode!),
      user: user,
      gender: user.gender == "0" ? Gender.female : Gender.male,
    );
    return BlocProvider(
      create: (context) => MyProfileCubit(context, state),
      child: const MyProfileView(),
    );
  }

  @override
  _MyProfileViewState createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  @override
  Widget build(BuildContext context) {
    final initialState = BlocProvider.of<MyProfileCubit>(context).state;

    return Scaffold(
      appBar: AppBar(
        leading: const BackIcon(),
        title: Text(S.of(context).titleMyProfile),
      ),
      body:
      BlocBuilder<MyProfileCubit, MyProfileState>(
        builder: (context, state) {

        if (state.isLoading) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        } else {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Form(
                    key: initialState.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SizedBox.square(
                            dimension: 140,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: BlocBuilder<MyProfileCubit, MyProfileState>(
                                      buildWhen: (previous, current) => previous.profilePic != current.profilePic,
                                      builder: (context, state) {
                                        if (state.profilePic.isNotEmpty) {
                                          return Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: Image.file(
                                              File(state.profilePic),
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        }
                                        return UserProfileImage(imageUrl: state.user.image??"");
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    child: Material(
                                      clipBehavior: Clip.hardEdge,
                                      type: MaterialType.circle,
                                      color: AppColor.white,
                                      elevation: 4,
                                      child: IconButton(
                                        padding: const EdgeInsets.all(4),
                                        visualDensity: VisualDensity.compact,
                                        onPressed: BlocProvider.of<MyProfileCubit>(context).selectProfilePhoto,
                                        icon: SquareSvgImageFromAsset(AppImages.imagesEdit, fit: BoxFit.contain, size: 20,color: AppColor.yellow,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Gap(16),
                        CommonTextField(
                          controller: initialState.nameController,
                          labelText: S.of(context).labelName,
                          hintText: S.of(context).hintName,
                          keyboardType: TextInputType.name,
                          // validator: (value) => value.isNullOrEmpty ? S.current.errorNameEmpty : null,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Builder(builder: (context) {
                              return SquareSvgImageFromAsset(
                                AppImages.imagesProfile,
                                size: 20,
                                color: IconTheme.of(context).color,
                              );
                            }),
                          ),
                        ),
                        const Gap(16),
                        CommonTextField(
                          controller: initialState.phoneController,
                          labelText: S.of(context).labelPhone,
                          hintText: S.of(context).hintPhone,
                          keyboardType: TextInputType.phone,
                          // validator: validateMobileNumber,
                          inputFormatters: [NumberInputFormatter(length: 11)],
                          prefixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Builder(builder: (context) {
                                  return SquareSvgImageFromAsset(AppImages.imagesPhone, size: 20, color: IconTheme.of(context).color);
                                }),
                              ),
                              BlocBuilder<MyProfileCubit, MyProfileState>(
                                buildWhen: (previous, current) => previous.country != current.country,
                                builder: (context, state) {
                                  return CountryCodePicker(
                                    selectedCountry: state.country,
                                    onSelectedCountryChanged: BlocProvider.of<MyProfileCubit>(context).onSelectedCountryChanged,
                                  );
                                },
                              ),
                              const SizedBox(height: 16, child: VerticalDivider(color: AppColor.grey)),
                              const Gap(8),
                            ],
                          ),
                        ),
                        const Gap(16),
                        BlocSelector<MyProfileCubit, MyProfileState, Country>(
                            selector: (state) => state.country,
                            builder: (context, country) => CommonTextField(
                              controller: initialState.emailController,
                              labelText: S.of(context).labelEmail,
                              hintText: S.of(context).hintEmail,
                              keyboardType: TextInputType.emailAddress,
                              isReadOnly: initialState.user.email!.isNotEmpty,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Builder(builder: (context) {
                                  return SquareSvgImageFromAsset(
                                    AppImages.imagesEmail,
                                    size: 20,
                                    color: IconTheme.of(context).color,
                                  );
                                }),
                              ),
                            )),
                        const Gap(16),
                        // CommonText.medium(S.of(context).labelGender, size: 14, color: AppColor.textPrimaryLight),
                        // const Gap(12),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: BlocSelector<MyProfileCubit, MyProfileState, Gender>(
                        //         selector: (state) => state.gender,
                        //         builder: (context, gender) => RadioListTile<Gender>(
                        //           value: Gender.male,
                        //           contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        //           dense: true,
                        //           tileColor: Colors.white,
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(8),
                        //             side: const BorderSide(color: AppColor.greyLight),
                        //           ),
                        //           groupValue: gender,
                        //           onChanged: BlocProvider.of<MyProfileCubit>(context).onGenderChanged,
                        //           title: CommonText.medium(S.of(context).labelMale, size: 16),
                        //         ),
                        //       ),
                        //     ),
                        //     const Gap(16),
                        //     Expanded(
                        //       child: BlocSelector<MyProfileCubit, MyProfileState, Gender>(
                        //         selector: (state) => state.gender,
                        //         builder: (context, gender) => RadioListTile<Gender>(
                        //           value: Gender.female,
                        //           contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        //           dense: true,
                        //           tileColor: Colors.white,
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(8),
                        //             side: const BorderSide(color: AppColor.greyLight),
                        //           ),
                        //           groupValue: gender,
                        //           onChanged: BlocProvider.of<MyProfileCubit>(context).onGenderChanged,
                        //           title: CommonText.medium(S.of(context).labelFemale, size: 16),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                       // const Gap(16),
                        Stack(
                          children: [
                            BlocSelector<MyProfileCubit, MyProfileState, TextEditingController>(
                              selector: (state) => state.countryController,
                              builder: (context, ctrl) => CommonTextField(
                                controller: ctrl,
                                labelText: S.of(context).labelCountryOfResidence,
                                hintText: S.of(context).hintCountryOfResidence,
                                isReadOnly: true,
                                // validator: (value) => value.isNullOrEmpty ? S.current.errorCountryEmpty : null,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Builder(builder: (context) {
                                    return SquareSvgImageFromAsset(
                                      AppImages.imagesAddress,
                                      size: 20,
                                      color: IconTheme.of(context).color,
                                    );
                                  }),
                                ),
                              ),
                            ),
                            Positioned.fill(
                                child: InkWell(
                                    onTap: () async {
                                      var country = await showCountryPickerSheet(context);
                                      BlocProvider.of<MyProfileCubit>(context).onSelectedResidentCountryChanged(country);
                                    },
                                    child: Container()))
                          ],
                        ),
                        const Gap(16),
                        CommonTextField(
                          controller: initialState.stateController,
                          labelText: S.of(context).labelStateOfResidence,
                          hintText: S.of(context).hintStateOfResidence,
                          keyboardType: TextInputType.name,
                          // validator: (value) => value.isNullOrEmpty ? S.current.errorCountryEmpty : null,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Builder(builder: (context) {
                              return SquareSvgImageFromAsset(
                                AppImages.imagesAddress,
                                size: 20,
                                color: IconTheme.of(context).color,
                              );
                            }),
                          ),
                        ),
                        const Gap(16),
                        CommonTextField(
                          controller: initialState.cityController,
                          labelText: S.of(context).labelCityOfResidence,
                          hintText: S.of(context).hintCityOfResidence,
                          keyboardType: TextInputType.name,
                          // validator: (value) => value.isNullOrEmpty ? S.current.errorCountryEmpty : null,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Builder(builder: (context) {
                              return SquareSvgImageFromAsset(
                                AppImages.imagesAddress,
                                size: 20,
                                color: IconTheme.of(context).color,
                              );
                            }),
                          ),
                        ),
                        const Gap(16),
                        CommonTextField(
                          controller: initialState.pinCodeController,
                          labelText: S.of(context).labelPinCodeOfResidence,
                          hintText: S.of(context).hintPinCodeOfResidence,
                          keyboardType: TextInputType.number,
                          // validator: (value) => value.isNullOrEmpty ? S.current.errorCountryEmpty : null,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Builder(builder: (context) {
                              return SquareSvgImageFromAsset(
                                AppImages.imagesAddress,
                                size: 20,
                                color: IconTheme.of(context).color,
                              );
                            }),
                          ),
                        ),
                        const Gap(42),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

      },
      ),
      bottomNavigationBar: BottomAppBar(
        child: IntrinsicHeight(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8 + context.bottomInset),
            child: CommonButton(
              onPressed: BlocProvider.of<MyProfileCubit>(context).save,
              label: S.of(context).btnSave,
            ),
          ),
        ),
      ),
    );
  }
}
