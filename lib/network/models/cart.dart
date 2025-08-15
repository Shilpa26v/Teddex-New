part of 'model.dart';

@JsonSerializable()
class Cart extends Equatable {
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int id;
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int productId;
  final String name;
  final String image;
  final String categoryName;
  final String created;
  String? currency;
  @JsonKey(fromJson: _doubleFromDynamic, toJson: _valueToString)
  final double price;

   Cart({
    required this.id,
    required this.productId,
    required this.name,
    required this.image,
    required this.categoryName,
    required this.price,
    required this.created,
    this.currency,
  });

  factory Cart.fromJson(Json json) => _$CartFromJson(json);

  Json toJson() => _$CartToJson(this);

  @override
  List<Object?> get props => [id, productId, name, image, categoryName, price, created, currency];

  Cart copyWith({
    int? id,
    int? productId,
    String? name,
    String? image,
    String? categoryName,
    String? created,
    String? currency,
    double? price,
  }) {
    return Cart(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      image: image ?? this.image,
      categoryName: categoryName ?? this.categoryName,
      created: created ?? this.created,
      currency: currency ?? this.currency,
      price: price ?? this.price,
    );
  }
}
