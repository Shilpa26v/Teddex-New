part of 'cart_view.dart';

class CheckoutSheet extends StatelessWidget {
  const CheckoutSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(builder: (context, state) {
      final currency = AppCubit.of(context, listen: true).currency;
      return Scrollable(
        viewportBuilder: (BuildContext context, ViewportOffset position) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              width: 64,
              height: 6,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.onBackground.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CommonText.bold(S.of(context).orderSummary, size: 20),
            ),
            Flexible(
              child: MediaQuery.removePadding(
                removeBottom: true,
                removeLeft: true,
                removeTop: true,
                removeRight: true,
                context: context,
                child: Scrollbar(
                  child: CustomScrollView(
                    shrinkWrap: true,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            var initialIndex = index ~/ 2;
                            if (index.isEven) {
                              var item = state.list[initialIndex];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CommonText.medium(item.name, size: 14),
                                          const Gap(4),
                                          CommonText.medium(
                                            item.categoryName,
                                            size: 13,
                                            color: AppColor.textPrimaryLight,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Gap(8),
                                    CommonText.bold(
                                      "${currency.currencyText} ${item.price.toString()}",
                                      size: 14,
                                      color: AppColor.green,
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const Divider(indent: 84, endIndent: 16);
                            }
                          },
                          childCount: (state.list.length * 2) - 1,
                          semanticIndexCallback: (child, index) => index ~/ 2,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + context.mediaQueryPadding.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText.medium(
                    S.of(context).totalDesign(state.list.length),
                    size: 16,
                  ),
                  const Gap(4),
                  CommonText.medium(
                    S
                        .of(context)
                        .totalAmount(currency.currencyText, state.totalAmount.toStringAsFixed(2)),
                    size: 16,
                  ),
                  const Gap(16),
                  CommonButton(
                    onPressed: BlocProvider.of<CartCubit>(context).createOrder,
                    label: S.of(context).btnContinue,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
