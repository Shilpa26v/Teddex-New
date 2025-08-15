import 'package:flutter/cupertino.dart';
import 'package:layout/layout.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/widgets/widgets.dart';

class RegistrationHeaderView extends StatelessWidget {
  final String title;
  final String subTitle;

  const RegistrationHeaderView({
    required this.title,
    required this.subTitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          CommonText.regular(title, size: 24, color: AppColor.textPrimary, fontFamily: kFontFamily),
          CommonText.regular(subTitle, size: 14, color: AppColor.textPrimaryMedium, textAlign: TextAlign.center),
          const Gap(36),
        ],
      ),
    );
  }
}
