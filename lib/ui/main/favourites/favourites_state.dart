part of 'favourites_view.dart';

class FavouritesState extends Equatable {
  final List<Product> list;
  final bool isLoading;
  final bool reachAtEnd;

  const FavouritesState({
    this.list = const [],
    this.reachAtEnd = false,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [list, isLoading, reachAtEnd];

  FavouritesState copyWith({
    List<Product>? list,
    bool? isLoading,
    bool? reachAtEnd,
  }) {
    return FavouritesState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      reachAtEnd: reachAtEnd ?? this.reachAtEnd,
    );
  }

}
