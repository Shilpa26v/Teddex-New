part of 'model.dart';
@JsonSerializable()
class CheckOtp {
  int otp;

  CheckOtp({required this.otp});

  factory CheckOtp.fromJson(Json json) => _$CheckOtpFromJson(json);

  Json toJson() => _$CheckOtpToJson(this);
}

