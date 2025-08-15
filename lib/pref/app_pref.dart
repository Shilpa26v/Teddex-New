import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:teddex/network/models/model.dart';

class AppPref {
  // region Pref Constants
  static const _isLogin = "is_login";
  static const _userToken = "user_token";
  static const _user = "user";
  static const _commonPage = "common_page";
  static const _currencySymbol = "currency_symbol";
  static const _isGuestUser = "is_guest_user";
  static const _cartCount = "cart_count";

  // endregion

  AppPref._();

  static late final SharedPreferences _preference;

  static Future<void> init() async {
    _preference = await SharedPreferences.getInstance();
  }

  static Future<bool> clear() {
    return _preference.clear();
  }

  // region isLogin
  static bool get isLogin => _preference.getBool(_isLogin) ?? false;

  static set isLogin(bool value) => _preference.setBool(_isLogin, value);

  // endregion

  // region isGuestUser
  static bool get isGuestUser => _preference.getBool(_isGuestUser) ?? false;

  static set isGuestUser(bool value) => _preference.setBool(_isGuestUser, value);

  // endregion

  // region userToken

  static String get userToken => _preference.getString(_userToken) ?? "";

  static set userToken(String value) => _preference.setString(_userToken, value);

  // endregion

  // region cartCount

  static int get cartCount => _preference.getInt(_cartCount) ?? 0;

  static set cartCount(int value) => _preference.setInt(_cartCount, value);

  // endregion

  // region user

  static User? get user =>
      _preference.containsKey(_user) ? User.fromJson(jsonDecode(_preference.getString(_user)!)) : null;

  static set user(User? user) {
    if (user == null) {
      _preference.remove(_user);
    } else {
      _preference.setString(_user, jsonEncode(user.toJson()));
    }
  }

  // endregion

  // region commonPage

  static CommonPage? get commonPage => _preference.containsKey(_commonPage)
      ? CommonPage.fromJson(jsonDecode(_preference.getString(_commonPage)!))
      : null;

  static set commonPage(CommonPage? commonPage) {
    if (commonPage == null) {
      _preference.remove(_commonPage);
    } else {
      _preference.setString(_commonPage, jsonEncode(commonPage.toJson()));
    }
  }

  // endregion

  // region currencySymbol

  static String get currencySymbol => _preference.getString(_currencySymbol) ?? "INR";

  static set currencySymbol(String userId) => _preference.setString(_currencySymbol, userId);

  // endregion

}
