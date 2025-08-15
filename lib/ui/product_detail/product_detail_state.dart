part of 'product_detail_view.dart';

class DesignSpecification {
  String name;
  String value;

  DesignSpecification(this.name, this.value);
}

class ProductDetailState extends Equatable {
  final PageController imagesController;
  final ProductDetail? detail;
  final List<DesignSpecification> designSpecificationList;
  final bool isLoading;
  final int cartCount;

  const ProductDetailState(
    this.imagesController, {
    this.detail,
    this.designSpecificationList=const [],
    this.isLoading = false,
    this.cartCount = 0,
  });

  @override
  List<Object?> get props => [detail, isLoading, designSpecificationList,cartCount];

  ProductDetailState copyWith({ProductDetail? detail, bool? isLoading, List<DesignSpecification>? designSpecificationList,int? cartCount}) {
    return ProductDetailState(
      imagesController,
      detail: detail ?? this.detail,
      designSpecificationList: designSpecificationList ?? this.designSpecificationList,
      isLoading: isLoading ?? this.isLoading,
      cartCount: cartCount ?? this.cartCount,
    );
  }
}
