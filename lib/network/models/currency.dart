part of 'model.dart';

@JsonSerializable()
class Currency {
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int id;
  final String code;
  @JsonKey(fromJson: _doubleFromDynamic, toJson: _valueToString)
  final double rate;
  final String symbol;
  final String currencyText;

  const Currency({
    required this.id,
    required this.code,
    required this.rate,
    required this.symbol,
    required this.currencyText,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => _$CurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyToJson(this);
}
