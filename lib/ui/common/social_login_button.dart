import 'package:flutter/material.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/widgets/widgets.dart';

class SocialLoginButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const SocialLoginButton({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      clipBehavior: Clip.hardEdge,
      elevation: 8,
      shadowColor: AppColor.greyLight.withAlpha(120),
      child: InkWell(
        highlightColor: AppColor.greyLight.withAlpha(150),
        splashColor: AppColor.greyLight,
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 100),
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SquareSvgImageFromAsset(icon, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
