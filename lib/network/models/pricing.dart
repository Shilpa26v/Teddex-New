part of 'model.dart';

@JsonSerializable()
class SubscriptionPlan {
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int id;
  final String name;
  @JsonKey(fromJson: _doubleFromDynamic, toJson: _valueToString)
  final double price;
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int categories;
  final String image;

  final String details;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.categories,
    required this.image,
    required this.details,
  });

  factory SubscriptionPlan.fromJson(Json json) => _$SubscriptionPlanFromJson(json);

  Json toJson() => _$SubscriptionPlanToJson(this);
}
