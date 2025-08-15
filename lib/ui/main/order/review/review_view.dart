import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layout/layout.dart';
import 'package:teddex/base/base.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/widgets/widgets.dart';

part 'review_bloc.dart';
part 'review_state.dart';

class ReviewArguments {
  final int productId;
  final int star;
  final String msg;

  const ReviewArguments({
    required this.productId,required this.star,required this.msg});
}

class ReviewView extends StatefulWidget {
  const ReviewView({Key? key}) : super(key: key);

  static const routeName = "/review_view";

  static Widget builder(BuildContext context) {
    assert(context.args != null && context.args is ReviewArguments);
    final state = ReviewState((context.args as ReviewArguments).productId, TextEditingController(text:(context.args as
    ReviewArguments).msg),review:(context.args as ReviewArguments).star );
    return BlocProvider(
      create: (context) => ReviewCubit(context, state),
      child: const ReviewView(),
    );
  }

  @override
  _ReviewViewState createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  @override
  Widget build(BuildContext context) {
    var initialState = BlocProvider.of<ReviewCubit>(context).state;
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (index) => Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: BlocSelector<ReviewCubit, ReviewState, int>(
                            selector: (state) => state.review,
                            builder: (context, review) {
                              return GestureDetector(
                                onTap: () => BlocProvider.of<ReviewCubit>(context).updateReview(index + 1),
                                child: AnimatedCrossFade(
                                  duration: const Duration(milliseconds: 100),
                                  crossFadeState: review > index ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                  firstChild: SquareSvgImageFromAsset(
                                    AppImages.imagesStarFilled,
                                    color: AppColor.yellow,
                                    size: 32,
                                    fit: BoxFit.contain,
                                  ),
                                  secondChild: SquareSvgImageFromAsset(
                                    AppImages.imagesStarOutlined,
                                    color: AppColor.yellow,
                                    size: 32,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              CommonTextField(
                controller: initialState.controller,
                labelText: S.of(context).labelReview,
                hintText: S.of(context).hintWriteHere,
                keyboardType: TextInputType.multiline,
                inputAction: TextInputAction.newline,
                minLines: 3,
                maxLines: 5,
              ),
              const Gap(16),
              CommonButton(
                onPressed: BlocProvider.of<ReviewCubit>(context).submit,
                label: S.of(context).btnSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
