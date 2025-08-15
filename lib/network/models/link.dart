part of 'model.dart';

@JsonSerializable()
class CommonPage {
  final String privacy;
  final String about;
  final String contact;
  final String term;
  final String refund;
  String? versionAndroid;
  String? versionIos;

   CommonPage({
    required this.privacy,
    required this.about,
    required this.contact,
    required this.term,
    required this.refund,
    this.versionAndroid,
    this.versionIos,
  });

  factory CommonPage.fromJson(Map<String, dynamic> json) => _$CommonPageFromJson(json);

  Map<String, dynamic> toJson() => _$CommonPageToJson(this);
}
