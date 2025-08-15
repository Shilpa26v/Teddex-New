part of '../widgets.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool isItalic;
  final double? height;
  final double? letterSpacing;
  final FontWeight fontWeight;
  final VoidCallback? onTap;
  final String fontFamily;
  final TextDecoration? decoration;

  const CommonText(
    this.text, {
    this.size = 12,
    this.color = AppColor.textPrimary,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.isItalic = false,
    this.height,
    this.letterSpacing,
    this.fontWeight = FontWeight.normal,
    this.onTap,
    this.fontFamily = kFontFamily,
    this.decoration,
    Key? key,
  }) : super(key: key);

  const CommonText.extraBold(
    this.text, {
    this.size = 12,
    this.color = AppColor.textPrimary,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.isItalic = false,
    this.height,
    this.letterSpacing,
    this.onTap,
    this.fontFamily = kFontFamily,
    this.decoration,
    Key? key,
  })  : fontWeight = FontWeight.w800,
        super(key: key);

  const CommonText.bold(
    this.text, {
    this.size = 12,
    this.color = AppColor.textPrimary,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.isItalic = false,
    this.height,
    this.letterSpacing,
    this.onTap,
    this.fontFamily = kFontFamily,
    this.decoration,
    Key? key,
  })  : fontWeight = FontWeight.w700,
        super(key: key);

  const CommonText.semiBold(
    this.text, {
    this.size = 12,
    this.color = AppColor.textPrimary,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.isItalic = false,
    this.height,
    this.letterSpacing,
    this.onTap,
    this.fontFamily = kFontFamily,
    this.decoration,
    Key? key,
  })  : fontWeight = FontWeight.w600,
        super(key: key);

  const CommonText.medium(
    this.text, {
    this.size = 12,
    this.color = AppColor.textPrimary,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.isItalic = false,
    this.height,
    this.letterSpacing,
    this.onTap,
    this.fontFamily = kFontFamily,
    this.decoration,
    Key? key,
  })  : fontWeight = FontWeight.w500,
        super(key: key);

  const CommonText.regular(
    this.text, {
    this.size = 12,
    this.color = AppColor.textPrimary,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.isItalic = false,
    this.height = 1.5,
    this.letterSpacing,
    this.onTap,
    this.fontFamily = kFontFamily,
    this.decoration,
    Key? key,
  })  : fontWeight = FontWeight.w400,
        super(key: key);

  const CommonText.light(
    this.text, {
    this.size = 12,
    this.color = AppColor.textPrimary,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.isItalic = false,
    this.height = 1.5,
    this.letterSpacing,
    this.onTap,
    this.fontFamily = kFontFamily,
    this.decoration,
    Key? key,
  })  : fontWeight = FontWeight.w300,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var child = Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        fontFamily: fontFamily,
        color: color,
        fontSize: size,
        fontStyle: isItalic ? FontStyle.italic : null,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration,
      ),
    );

    return onTap != null ? GestureDetector(onTap: onTap, child: child) : child;
  }
}
