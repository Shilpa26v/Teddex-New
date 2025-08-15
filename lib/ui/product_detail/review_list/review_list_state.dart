part of 'review_list_view.dart';

class ReviewListState extends Equatable {
  final List<Review> listReview;

  const ReviewListState({
    this.listReview = const [],
  });

  @override
  List<Object?> get props => [listReview];

  ReviewListState copyWith({
    List<Review>? listReview,
  }) {
    return ReviewListState(
      listReview: listReview ?? this.listReview,
    );
  }
}
