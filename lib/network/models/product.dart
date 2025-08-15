part of 'model.dart';

@JsonSerializable()
class ProductDetail extends Equatable {
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int id;
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int categoryId;
  final String mainCatName;
  final String subCatName;
  final String subSubCatName;
  final String name;
  @JsonKey(fromJson: _doubleFromDynamic, toJson: _valueToString)
  final double price;
  @JsonKey(fromJson: _doubleFromDynamic, toJson: _valueToString)
  final double sellPrice;
  String? details;
  String? stitch;
  String? needle;
  String? area;
  String? format;
  String? heights;
  String? width;
  String? pdfFile;
  String? zipName;
  @JsonKey(fromJson: _intFromDynamic)
  int? profileShow;
  String? bannerName;
  String? vendorId;
  String? vendorName;
  String? profileImage;
  @JsonKey(fromJson: _boolFromDynamic)
  final bool isFavourite;
  @JsonKey(fromJson: _boolFromDynamic)
  final bool isAbleDownload;
  @JsonKey(defaultValue: [])
  final List<ProductImage> images;
  @JsonKey(defaultValue: [])
  final List<Product> related;
  @JsonKey(defaultValue: [])
  final List<Review> reviews;
  Specification? filters;

  ProductDetail({
    required this.id,
    required this.categoryId,
    required this.mainCatName,
    required this.subCatName,
    required this.subSubCatName,
    required this.name,
    required this.price,
    required this.sellPrice,
    this.details,
    this.stitch,
    this.heights,
    this.profileShow,
    this.width,
    this.pdfFile,
    this.zipName,
    this.needle,
    this.area,
    this.format,
    this.filters,
    this.bannerName,
    this.vendorId,
    this.vendorName,
    this.profileImage,
    required this.isFavourite,
    this.isAbleDownload = false,
    this.images = const [],
    this.related = const [],
    this.reviews = const [],
  });

  factory ProductDetail.fromJson(Json json) => _$ProductDetailFromJson(json);

  Json toJson() => _$ProductDetailToJson(this);

  @override
  List<Object?> get props => [
        id,
        mainCatName,
        subCatName,
        subSubCatName,
        name,
        price,
        sellPrice,
    filters,
        details,
        stitch,
        heights,
        width,
        needle,
        area,
        format,
        pdfFile,
        zipName,
        images,
        bannerName,
        isFavourite,
        related,
      ];

  ProductDetail copyWith({
    int? id,
    int? categoryId,
    String? mainCatName,
    String? subCatName,
    String? subSubCatName,
    String? name,
    double? price,
    double? sellPrice,
    String? details,
    String? stitch,
    String? heights,
    String? width,
    String? pdfFile,
    String? format,
    String? needle,
    String? area,
    String? zipName,
    String? bannerName,
    bool? isFavourite,
    bool? isAbleDownload,
    Specification? filters,
    List<ProductImage>? images,
    List<Product>? related,
    List<Review>? reviews,
  }) {
    return ProductDetail(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      mainCatName: mainCatName ?? this.mainCatName,
      subCatName: subCatName ?? this.subCatName,
      subSubCatName: subSubCatName ?? this.subSubCatName,
      name: name ?? this.name,
      filters: filters ?? this.filters,
      price: price ?? this.price,
      sellPrice: sellPrice ?? this.sellPrice,
      details: details ?? this.details,
      stitch: stitch ?? this.stitch,
      heights: heights ?? this.heights,
      width: width ?? this.width,
      area: area ?? this.area,
      needle: needle ?? this.needle,
      format: format ?? this.format,
      pdfFile: pdfFile ?? this.pdfFile,
      zipName: zipName ?? this.zipName,
      bannerName: bannerName ?? this.bannerName,
      isFavourite: isFavourite ?? this.isFavourite,
      isAbleDownload: isAbleDownload ?? this.isAbleDownload,
      images: images ?? this.images,
      related: related ?? this.related,
      reviews: reviews ?? this.reviews,
    );
  }
}

@JsonSerializable()
class Specification {
  final Map<String, dynamic> filters;

  Specification({required this.filters});

  factory Specification.fromJson(Map<String, dynamic> json) {
    return Specification(filters: json);
  }

  Map<String, dynamic> toJson() {
    return filters;
  }
}


@JsonSerializable()
class ProductImage {
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int id;
  final String? thumb;
  final String main;
  final int isGallery;

  const ProductImage({
    required this.id,
    required this.thumb,
    required this.main,
    required this.isGallery,
  });

  factory ProductImage.fromJson(Json json) => _$ProductImageFromJson(json);

  Json toJson() => _$ProductImageToJson(this);
}

@JsonSerializable()
class Review {
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int id;
  final String name;
  final String messages;
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int star;

  const Review({
    required this.id,
    required this.name,
    required this.messages,
    required this.star,
  });

  factory Review.fromJson(Json json) => _$ReviewFromJson(json);

  Json toJson() => _$ReviewToJson(this);
}







