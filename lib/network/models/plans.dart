part of 'model.dart';

@JsonSerializable()
class MyPlan {
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int id;
  final String name;
  @JsonKey(fromJson: _doubleFromDynamic, toJson: _valueToString)
  final double price;
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int totalDownload;
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int userDownload;
  final String planStatus;
  final String created;

  const MyPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.totalDownload,
    required this.userDownload,
    required this.planStatus,
    required this.created,
  });

  factory MyPlan.fromJson(Map<String, dynamic> json) => _$MyPlanFromJson(json);

  Map<String, dynamic> toJson() => _$MyPlanToJson(this);
}
