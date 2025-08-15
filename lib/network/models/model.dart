import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:teddex/helpers/helpers.dart';

part 'cart.dart';
part 'currency.dart';
part 'dashboard.dart';
part 'link.dart';
part 'model.g.dart';
part 'order.dart';
part 'plans.dart';
part 'pricing.dart';
part 'product.dart';
part 'user.dart';
part 'check_otp.dart';
part 'faq.dart';

typedef Json = Map<String, dynamic>;
typedef JsonEntry = MapEntry<String, dynamic>;

@JsonSerializable()
class EncryptData {
  String mac;
  String value;

  EncryptData({required this.mac, required this.value});

  factory EncryptData.fromJson(dynamic json) => _$EncryptDataFromJson(json);

  Map<String, dynamic> toJson() => _$EncryptDataToJson(this);

  @override
  String toString() => 'EncryptData{mac: $mac, value: $value}';
}

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class CommonResponse<T> {
  String message;
  T data;

  CommonResponse({required this.message, required this.data});

  factory CommonResponse.fromJson(dynamic json, T Function(Object?) fromJsonT) =>
      _$CommonResponseFromJson(json, fromJsonT);

  @override
  String toString() => 'CommonResponse{data: $data}';
}

double _doubleFromDynamic(value) {
  return value.toString().toDouble();
}

bool _boolFromDynamic(value) {
  if (value is num) {
    return value.toInt() == 1;
  } else if (value is bool) {
    return value;
  }
  return false;
}

int _intFromDynamic(value) {
  return value.toString().toInt();
}

String _valueToString(value) => value.toString();
