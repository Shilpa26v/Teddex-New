part of 'model.dart';

@JsonSerializable()
class Order {
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int designId;
  final String orderId;
  final String image;
  final String downloadLink;
  final String categoryName;
  String? currency;
  final String paymentBy;
  final String date;
  final String name;
  @JsonKey(fromJson: _doubleFromDynamic, toJson: _valueToString)
  final double price;
  @JsonKey(fromJson: _intFromDynamic)
  final int star;
  @JsonKey(defaultValue: "")
  final String reviewMsg;

  Order({
    required this.designId,
    required this.orderId,
    required this.image,
    required this.downloadLink,
    required this.categoryName,
    this.currency,
    required this.paymentBy,
    required this.date,
    required this.name,
    required this.price,
    required this.star,
    this.reviewMsg = "",
  });

  factory Order.fromJson(Json json) => _$OrderFromJson(json);

  Json toJson() => _$OrderToJson(this);

  Order copyWith({
    int? star,
    String? reviewMsg,
  }) {
    return Order(
      designId: designId,
      orderId: orderId,
      image: image,
      downloadLink: downloadLink,
      categoryName: categoryName,
      currency: currency,
      paymentBy: paymentBy,
      date: date,
      name: name,
      price: price,
      star: star ?? this.star,
      reviewMsg: reviewMsg ?? this.reviewMsg,
    );
  }
}

@JsonSerializable()
class CreateOrderResponse {
  final int orderId;
  final String razorOrderId;
  final String razorKey;
  final String razorSecret;
  final double amount;
  final String currency;

  const CreateOrderResponse({
    required this.orderId,
    required this.razorOrderId,
    required this.razorKey,
    required this.razorSecret,
    required this.amount,
    required this.currency,
  });

  factory CreateOrderResponse.fromJson(Json json) => _$CreateOrderResponseFromJson(json);

  Json toJson() => _$CreateOrderResponseToJson(this);
}
