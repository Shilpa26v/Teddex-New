import 'package:teddex/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:teddex/app/app.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/widgets/widgets.dart';

class ProductItemView extends StatelessWidget {
  final Product product;
  final VoidCallback onPressed;
  final bool isLike;
  final ValueChanged<bool> onLike;

  const ProductItemView({
    Key? key,
    required this.onPressed,
    required this.product,
    required this.isLike,
    required this.onLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currency = AppCubit.of(context, listen: true).currency;
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      color: AppColor.scaffoldBackground,
      child: InkWell(
        highlightColor: AppColor.greyLight.withAlpha(150),
        splashColor: AppColor.greyLight,
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 0.9,
              child: Stack(
                children: [
                  Align(
                      alignment: AlignmentDirectional.center,

                      child: CachedImage(product.thumbName, fit: BoxFit.fill)),
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LikeIcon(value: isLike, onChanged: onLike),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: CommonText.regular(
                            S.of(context).designCode(product.id),
                            color: AppColor.textPrimaryMedium,
                            size: 12,
                          ),
                        ),
                        const Gap(4),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text.rich(
                              TextSpan(
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  if (product.sellPrice != product.price) ...[
                                    TextSpan(
                                      text: currency.currencyText + product.sellPrice.toStringAsFixed(2),
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: AppColor.textPrimaryMedium,
                                      ),
                                    ),
                                    const WidgetSpan(child: SizedBox(width: 4)),
                                  ],
                                  TextSpan(
                                    text: currency.currencyText + product.price.toStringAsFixed(2),
                                    style: const TextStyle(
                                      color: AppColor.green,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  // if (product.sellPrice != product.price) ...[
                                  //   const WidgetSpan(child: SizedBox(width: 4)),
                                  //   TextSpan(
                                  //     text: S
                                  //         .of(context)
                                  //         .discount((100 - (product.price * 100 / product.sellPrice)).toStringAsFixed(1)),
                                  //     style: const TextStyle(
                                  //       color: AppColor.yellow,
                                  //     ),
                                  //   ),
                                  // ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
