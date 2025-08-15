part of 'cart_view.dart';

class CartState extends Equatable {
  final List<Cart> list;
  final double totalAmount;
  final bool isLoading;
  final bool reachAtEnd;

  const CartState({
    this.list = const [],
    this.totalAmount = 0.0,
    this.isLoading = false,
    this.reachAtEnd = false,
  });

  @override
  List<Object?> get props => [list, totalAmount, isLoading, reachAtEnd];

  CartState copyWith({
    List<Cart>? list,
    double? totalAmount,
    bool? reachAtEnd,
    bool? isLoading,
  }) {
    return CartState(
      list: list ?? this.list,
      totalAmount: totalAmount ?? this.totalAmount,
      isLoading: isLoading ?? this.isLoading,
      reachAtEnd: reachAtEnd ?? this.reachAtEnd,
    );
  }
}
