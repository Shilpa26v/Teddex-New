part of '../widgets.dart';

class CommonButton extends StatelessWidget {
  final String? label;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final double textSize;
  final Color labelColor;
  final Widget? child;

  const CommonButton({
    required this.onPressed,
    this.label,
    this.child,
    this.padding,
    this.textSize = 16.0,
    this.labelColor = AppColor.white,
    Key? key,
  })  : assert(child == null || label == null, "cannot assign both at once."),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      clipBehavior: Clip.hardEdge,
      style: padding == null ? null : ButtonStyle(padding: MaterialStateProperty.all(padding)),
      child: Center(
        child: child ??
            CommonText.bold(
              label!,
              size: textSize,
              color: labelColor,
              textAlign: TextAlign.center,
            ),
      ),
    );
  }
}

class CommonOutlinedButton extends StatelessWidget {
  final String? label;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final double textSize;
  final Color labelColor;
  final Widget? child;

  const CommonOutlinedButton({
    required this.onPressed,
    this.label,
    this.child,
    this.padding,
    this.textSize = 16.0,
    this.labelColor = AppColor.primary,
    Key? key,
  })  : assert(child == null || label == null, "cannot assign both at once."),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      clipBehavior: Clip.hardEdge,
      style: padding == null ? null : ButtonStyle(padding: MaterialStateProperty.all(padding)),
      child: Center(
        child: child ??
            CommonText.bold(
              label!,
              size: textSize,
              color: labelColor,
              textAlign: TextAlign.center,
            ),
      ),
    );
  }
}
