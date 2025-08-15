import 'package:teddex/generated/l10n.dart';

const kEmailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
const kPasswordPattern = r'^.*(?=.{8,})((?=.*[!@#$%^&*_]){1})(?=.*\d)((?=.*[a-zA-Z]){1}).*$';

String? validateINDMobileNumber(String? value) {
  if (value == null) {
    return null;
  } else if (value.trim().isEmpty) {
    return S.current.errorPhoneEmpty;
  } else if (value.length < 10 ) {
    return S.current.errorPhoneInvalid;
  } else {
    return null;
  }
}


String? validateMobileNumber(String? value) {
  if (value == null) {
    return null;
  } else if (value.trim().isEmpty) {
    return S.current.errorPhoneEmpty;
  } else if (value.length < 4 ) {
    return S.current.errorPhoneInvalid;
  } else {
    return null;
  }
}

String? validateEmail(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return S.current.errorEmailEmpty;
  } else if (!RegExp(kEmailPattern).hasMatch(value.trim())) {
    return S.current.errorEmailInvalid;
  } else {
    return null;
  }
}

String? validatePassword(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return S.current.errorPasswordEmpty;
  } else if (value.trim().length < 8) {
    return S.current.errorPasswordInvalid;
  } else {
    return null;
  }
}

String? validateOldPassword(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return S.current.errorOldPasswordEmpty;
  } else {
    return null;
  }
}

String? validateConfirmPassword(String? value, String password) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return S.current.errorConfirmPasswordEmpty;
  } else if (value != password) {
    return S.current.errorPasswordMatch;
  } else {
    return null;
  }
}

String? validateOtp(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return S.current.errorVerificationCodeEmpty;
  } else if (value.trim().length !=6 ) {
    return S.current.errorVerificationCode;
  } else {
    return null;
  }
}
