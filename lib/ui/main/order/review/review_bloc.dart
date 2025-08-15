part of 'review_view.dart';

class ReviewCubit extends BaseCubit<ReviewState> {
  ReviewCubit(BuildContext context, ReviewState initialState) : super(context, initialState);

  void updateReview(int review) {
    emit(state.copyWith(review: review));
  }

  Future<void> submit() async {
    if(state.review>0) {
      var response = await processApi(
            () => apiClient.addReview(productId: state.productId, message: state.controller.text, star: state.review),
        doShowLoader: true,
      );
      if (response?.data != null) {
        Navigator.of(context).pop({
          "star": state.review,
          "message": state.controller.text,
        });
      }
    }
  }
}
