import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class CountryPickerUtils {
  static Country getCountryByPhoneCode(String phoneCode) {
    try {
      return countryList.firstWhere(
        (country) => country.phoneCode.toLowerCase() == phoneCode.toLowerCase(),
      );
    } catch (error) {
      throw Exception("The initialValue provided is not a supported phone code!");
    }
  }

  static Country getCountryByIso3Code(String iso3Code) {
    try {
      return countryList.firstWhere(
        (country) => country.iso3Code.toLowerCase() == iso3Code.toLowerCase(),
      );
    } catch (error) {
      throw Exception("The initialValue provided is not a supported iso 3 code!");
    }
  }

  static Country getCountryByIsoCode(String isoCode) {
    try {
      return countryList.firstWhere(
        (country) => country.isoCode.toLowerCase() == isoCode.toLowerCase(),
      );
    } catch (error) {
      throw Exception("The initialValue provided is not a supported iso code!");
    }
  }

  static Country getCountryByName(String name) {
    try {
      return countryList.firstWhere(
        (country) => country.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (error) {
      throw Exception("The initialValue provided is not a supported name!");
    }
  }

  static String getFlagImageAssetPath(String isoCode) {
    return "assets/images/${isoCode.toLowerCase()}.png";
  }

  static Widget getDefaultFlagImage(Country country, {double width = 30.0, double height = 20.0}) {
    return Image.asset(
      CountryPickerUtils.getFlagImageAssetPath(country.isoCode),
      height: height,
      width: width,
      fit: BoxFit.fill,
      package: "country_picker",
    );
  }
}
