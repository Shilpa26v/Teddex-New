part of 'my_profile_view.dart';

class MyProfileCubit extends BaseCubit<MyProfileState> {
  MyProfileCubit(BuildContext context, MyProfileState initialState) : super(context, initialState) {
    Timer.run(_getProfile);
  }

  Future<void> _getProfile() async {
    emit(state.copyWith(isLoading: true));
    var response = await processApi(() => apiClient.getProfile());
    response?.data.let((it) {
      AppPref.user = it;

      var nameCtrl = state.nameController;
      nameCtrl.text = it.name ?? "";
      var phoneCtrl = state.phoneController;
      phoneCtrl.text = it.mobile ?? "";
      var emailCtrl = state.emailController;
      emailCtrl.text = it.email ?? "";
      var countryCtrl = state.countryController;
      countryCtrl.text = it.country ?? "";
      var stateCtrl = state.stateController;
      stateCtrl.text = it.state ?? "";
      var cityCtrl = state.cityController;
      cityCtrl.text = it.city ?? "";
      var pincodeCtrl = state.pinCodeController;
      pincodeCtrl.text = it.pincode ?? "";
      var machineTypeCtrl = state.machineTypeController;
      machineTypeCtrl.text = it.useMachine ?? "";
      var designFormatCtrl = state.designFormatController;
      designFormatCtrl.text = it.designFormat ?? "";
      var designTypeCtrl = state.designTypeController;
      designTypeCtrl.text = it.designType ?? "";

      emit(state.copyWith(
          user: it,
          isLoading: false,
          nameController: nameCtrl,
          emailController: emailCtrl,
          phoneController: phoneCtrl,
          countryController: countryCtrl,
          cityController: cityCtrl,
          stateController: stateCtrl,
          machineTypeController: machineTypeCtrl,
          designFormatController: designFormatCtrl,
          designTypeController: designTypeCtrl));
    });
  }

  Future<void> selectProfilePhoto() async {
    var image = await ImagePicker().pickImage(
      context,
      hasRemoveOption: true,
      onRemove: () => emit(state.copyWith(profilePic: "")),
    );
    if (image != null) {
      emit(state.copyWith(profilePic: image.path));
      var data = processApi(() => apiClient.updateProfileImage(File(image.path)), doShowLoader: true);
    }
  }

  void onSelectedCountryChanged(Country country) {
    emit(state.copyWith(country: country));
  }

  void onSelectedResidentCountryChanged(Country? country) {
    if (country == null) return;
    var ctrl = state.countryController;
    ctrl.text = country.name;
    emit(state.copyWith(countryController: ctrl));
    Log.debug("cont..${state.countryController.text}");
  }

  Future<void> save() async {
    Log.debug("gender..${state.gender.value.toString()}");
    context.hideKeyboard();
    if (state.formKey.currentState!.validate()) {
      var response = await processApi(
        () => apiClient.updateProfile(
          name: state.nameController.text,
          email: state.emailController.text,
          country: state.countryController.text,
          mobile: state.phoneController.text.replaceAll(" ", " "),
          countryCode: state.country.phoneCode,
          state: state.stateController.text,
          pincode: state.pinCodeController.text,
          city: state.cityController.text,
        ),
        doShowLoader: true,
      );
      response?.data.let((it) {
        eventBus.fire("user_updated");
        Navigator.of(context).pop();
      });
    }
  }

  void onGenderChanged(Gender? value) {
    if (value == null) return;
    emit(state.copyWith(gender: value));
  }
}
