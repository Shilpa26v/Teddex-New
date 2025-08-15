part of 'model.dart';
@JsonSerializable()
class FAQ {
  int id;
  String que;
  String ans;

  FAQ({required this.id,required this.que,required this.ans});

  factory FAQ.fromJson(Json json) => _$FAQFromJson(json);

  Json toJson() => _$FAQToJson(this);
}

