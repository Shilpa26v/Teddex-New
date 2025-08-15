part of 'review_view.dart';

class ReviewState extends Equatable {
  final int productId;
  final TextEditingController controller;
  final int review;

  const ReviewState(this.productId, this.controller, {this.review = 5});

  @override
  List<Object?> get props => [review];

  ReviewState copyWith({
    int? review,
  }) {
    return ReviewState(
      productId,
      controller,
      review: review ?? this.review,
    );
  }
}
