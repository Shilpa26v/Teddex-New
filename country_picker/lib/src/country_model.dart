import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String name;
  final String isoCode;
  final String iso3Code;
  final String phoneCode;

  const Country({
    required this.isoCode,
    required this.iso3Code,
    required this.phoneCode,
    required this.name,
  });

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      name: map['name'] as String,
      isoCode: map['isoCode'] as String,
      iso3Code: map['iso3Code'] as String,
      phoneCode: map['phoneCode'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isoCode': isoCode,
      'iso3Code': iso3Code,
      'phoneCode': phoneCode,
    };
  }

  ///this method will prevent the override of toString
  String countryAsString() {
    return '+${this.phoneCode} ${this.name}';
  }

  @override
  List<Object?> get props => [isoCode, iso3Code, phoneCode, name];
}
