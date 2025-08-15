part of 'my_profile_view.dart';

class MyProfileState extends Equatable {
  final User user;
  final GlobalKey<FormState> formKey;
  final String profilePic;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController countryController;
  final TextEditingController stateController;
  final TextEditingController cityController;
  final TextEditingController pinCodeController;
  final TextEditingController machineTypeController;
  final TextEditingController designFormatController;
  final TextEditingController designTypeController;
  final Country country;
  final Gender gender;
  final bool isLoading;

  @override
  List<Object?> get props => [
        profilePic,
        gender,
        countryController,
        phoneController,
        isLoading,
        nameController,
        stateController,
        cityController,
        pinCodeController,
        machineTypeController,
        designFormatController,
        designTypeController
      ];

  const MyProfileState(
    this.formKey,
    this.nameController,
    this.phoneController,
    this.emailController,
    this.countryController,
    this.stateController,
    this.cityController,
    this.pinCodeController,
    this.machineTypeController,
    this.designFormatController,
    this.designTypeController, {
    required this.country,
    required this.user,
    this.gender = Gender.male,
    this.profilePic = "",
    this.isLoading = false,
  });

  MyProfileState copyWith({
    Country? country,
    User? user,
    TextEditingController? countryController,
    TextEditingController? pinCodeController,
    TextEditingController? stateController,
    TextEditingController? cityController,
    TextEditingController? nameController,
    TextEditingController? phoneController,
    TextEditingController? emailController,
    TextEditingController? machineTypeController,
    TextEditingController? designFormatController,
    TextEditingController? designTypeController,
    String? profilePic,
    Gender? gender,
    bool? isLoading,
  }) {
    return MyProfileState(
      formKey,
      nameController ?? this.nameController,
      phoneController ?? this.phoneController,
      emailController ?? this.emailController,
      countryController ?? this.countryController,
      isLoading: isLoading ?? this.isLoading,
      stateController ?? this.stateController,
      cityController ?? this.cityController,
      pinCodeController ?? this.pinCodeController,
      machineTypeController ?? this.machineTypeController,
      designFormatController ?? this.designFormatController,
      designTypeController ?? this.designTypeController,
      country: country ?? this.country,
      user: user ?? this.user,
      profilePic: profilePic ?? this.profilePic,
      gender: gender ?? this.gender,
    );
  }
}
