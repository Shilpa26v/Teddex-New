import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:layout/layout.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/widgets/widgets.dart';

class MethodOptionSheet extends StatelessWidget {
  final ValueNotifier<String> selectedMethod = ValueNotifier("");

  MethodOptionSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: context.theme.copyWith(
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColor.greyLight, width: 2),
          ),
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          clipBehavior: Clip.hardEdge,
          color: AppColor.white,
        ),
      ),
      child: Scrollable(
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
              child: CommonText.bold(S.of(context).titleChoosePaymentMethod, size: 20),
            ),
            Card(
              child: InkWell(
                onTap: () => onSelectedPaymentMethodChanged("razor"),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        color: AppColor.greyLight,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: SquareSvgImageFromAsset(AppImages.imagesRazorPay),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: CommonText.bold(S.of(context).optionRazorPay, size: 16),
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: selectedMethod,
                        builder: (context, value, _) {
                          return Radio(
                            value: "razor",
                            groupValue: value,
                            onChanged: onSelectedPaymentMethodChanged,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () => onSelectedPaymentMethodChanged("paypal"),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        color: AppColor.greyLight,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: SquareSvgImageFromAsset(AppImages.imagesPayPal),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: CommonText.bold(S.of(context).optionPayPal, size: 16),
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: selectedMethod,
                        builder: (context, value, _) {
                          return Radio(
                            value: "paypal",
                            groupValue: value,
                            onChanged: onSelectedPaymentMethodChanged,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + context.mediaQueryPadding.bottom),
              child: ValueListenableBuilder<String>(
                valueListenable: selectedMethod,
                builder: (context, value, _) => CommonButton(
                  onPressed: value.isEmpty ? null : () => Navigator.of(context).pop(selectedMethod.value),
                  label: S.of(context).btnContinue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSelectedPaymentMethodChanged(String? value) {
    if (value != null) {
      selectedMethod.value = value;
    }
  }
}
