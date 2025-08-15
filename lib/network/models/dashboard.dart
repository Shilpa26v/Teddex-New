part of 'model.dart';

@JsonSerializable()
class Dashboard {
  List<CategoryWiseProducts>? categories;
  List<Category>? trendingCategory;
  List<Product>? trendingProduct;
  List<Product>? mostPopularProduct;
  List<HomeProductSections>? homeProductSections;
  HomeBanner? extraBanner;

  Dashboard({
     this.categories,
     this.trendingCategory,
     this.trendingProduct,
     this.mostPopularProduct,
     this.homeProductSections=const [],
     this.extraBanner,
  });

  factory Dashboard.fromJson(Json json) => _$DashboardFromJson(json);

  Json toJson() => _$DashboardToJson(this);
}

@JsonSerializable()
class HomeProductSections {
  List<Product>? products;
  String? name;

  HomeProductSections({
    this.products,
    this.name,
  });

  factory HomeProductSections.fromJson(Json json) => _$HomeProductSectionsFromJson(json);

  Json toJson() => _$HomeProductSectionsToJson(this);
}

@JsonSerializable()
class CategoryWiseProducts extends Category {
  @JsonKey(fromJson: _parseProductListFromJson)
  List<Product> products;

  CategoryWiseProducts({
    required int id,
    required String name,
    String? subTitle,
     String? mobileVertical,
     String? mobileHorizontal,
    required this.products,
  }) : super(
          id: id,
          name: name,
          subTitle: subTitle,
          mobileVertical: mobileVertical,
          mobileHorizontal: mobileHorizontal,
        );

  factory CategoryWiseProducts.fromJson(Json json) => _$CategoryWiseProductsFromJson(json);

  @override
  Json toJson() => _$CategoryWiseProductsToJson(this);
}

@JsonSerializable()
class Product extends Equatable {
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int id;
  final String name;
  @JsonKey(defaultValue: "")
  final String image;
  @JsonKey(defaultValue: "")
  final String thumbName;
  @JsonKey(fromJson: _doubleFromDynamic, toJson: _valueToString)
  final double price;
  @JsonKey(fromJson: _doubleFromDynamic, toJson: _valueToString)
  final double sellPrice;
  @JsonKey(fromJson: _boolFromDynamic)
  final bool isFavourite;

  const Product({
    required this.id,
    required this.name,
    this.image = "",
    this.thumbName = "",
    required this.price,
    required this.sellPrice,
    this.isFavourite = false,
  });

  factory Product.fromJson(Json json) => _$ProductFromJson(json);

  Json toJson() => _$ProductToJson(this);

  @override
  List<Object?> get props => [id, name, image, thumbName, price, sellPrice, isFavourite];

  Product copyWith({
    int? id,
    String? name,
    String? image,
    String? thumbName,
    double? price,
    double? sellPrice,
    bool? isFavourite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      thumbName: thumbName ?? this.thumbName,
      price: price ?? this.price,
      sellPrice: sellPrice ?? this.sellPrice,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}

@JsonSerializable()
class HomeBanner {
  String image;

  HomeBanner({required this.image});

  factory HomeBanner.fromJson(Json json) => _$HomeBannerFromJson(json);

  Json toJson() => _$HomeBannerToJson(this);
}

@JsonSerializable()
class Category {
  @JsonKey(fromJson: _intFromDynamic, toJson: _valueToString)
  final int id;
  final String name;
  final String? subTitle;
  @JsonKey(defaultValue: '')
  final String details;
  @JsonKey(name: "mobile_verticle")
   String? mobileVertical;
   String? mobileHorizontal;
  @JsonKey(fromJson: _parseCategoryList)
  final List<Category> subCategory;

  Category({
    required this.id,
    required this.name,
    this.subTitle,
    this.details = '',
     this.mobileVertical,
     this.mobileHorizontal,
    this.subCategory = const [],
  });

  factory Category.fromJson(Json json) => _$CategoryFromJson(json);

  Json toJson() => _$CategoryToJson(this);

  static List<Category> _parseCategoryList(value) {
    if (value is Iterable) {
      return value.map((e) => e as Map<String, dynamic>).map(Category.fromJson).toList();
    }
    return [];
  }
}

List<Product> _parseProductListFromJson(value) {
  if (value?.toString().isNullOrEmpty ?? true) return [];
  return List.from(value).map((json) => Product.fromJson(json)).toList();
}
