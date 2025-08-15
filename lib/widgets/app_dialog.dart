import 'package:teddex/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:layout/layout.dart' as layout;

class AppDialogButton {
  final String label;
  final VoidCallback? onPressed;

  const AppDialogButton({
    required this.label,
    required this.onPressed,
  });
}

class AppDialog extends StatelessWidget {
  final String title, content;
  final bool? isEnableBack;
  final bool isShowPositiveButtonBorder;
  final AppDialogButton? positiveButton, negativeButton, otherButton;

  const AppDialog({
    Key? key,
    this.isEnableBack,
    required this.title,
    required this.content,
    this.positiveButton,
    this.negativeButton,
    this.otherButton,
    this.isShowPositiveButtonBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dialogTheme = theme.dialogTheme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return WillPopScope(
      onWillPop: () async {
        return isEnableBack ?? true;
      },
      child: Dialog(
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(title, style: dialogTheme.titleTextStyle, textAlign: TextAlign.center),
                      const Gap(8),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(content, style: dialogTheme.contentTextStyle, textAlign: TextAlign.center),
                        ),
                      ),
                      const Gap(8),
                    ],
                  ),
                ),
              ),
              if (otherButton != null)
                InkWell(
                  onTap: otherButton!.onPressed ?? () => Navigator.of(context).pop(true),
                  splashColor: colorScheme.primary.withOpacity(0.1),
                  highlightColor: colorScheme.primary.withOpacity(0.05),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
                    child: Text(
                      otherButton!.label,
                      style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(4),
                color: AppColor.primary,
                child: Row(
                  children: [
                    if (positiveButton != null)
                      InkWell(
                        onTap: positiveButton!.onPressed ?? () => Navigator.of(context).pop(true),
                        splashColor: colorScheme.error.withOpacity(0.1),
                        highlightColor: colorScheme.error.withOpacity(0.05),
                        child: Container(
                          width: isShowPositiveButtonBorder ? 150 : null,
                          decoration: BoxDecoration(
                              color: isShowPositiveButtonBorder ? AppColor.primary : AppColor.transparent,
                              borderRadius: const BorderRadius.all(Radius.circular(8))),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
                          child: Text(
                            positiveButton!.label,
                            style: isShowPositiveButtonBorder
                                ? textTheme.bodyMedium?.copyWith(color: AppColor.white)
                                : textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    if (positiveButton != null && negativeButton != null)
                      SizedBox(
                        height: 24,
                        width: 1,
                        child: Container(
                          color: AppColor.deselected,
                        ),
                      ),
                    if (negativeButton != null)
                      Expanded(
                        child: InkWell(
                          onTap: negativeButton!.onPressed ?? () => Navigator.of(context).pop(false),
                          splashColor: colorScheme.error.withOpacity(0.1),
                          highlightColor: colorScheme.error.withOpacity(0.05),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
                            child: Text(
                              negativeButton!.label,
                              style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  bool? isEnableBack,
  AppDialogButton? positiveButton,
  AppDialogButton? negativeButton,
  AppDialogButton? otherButton,
  bool barrierDismissible = true,
  RouteSettings? routeSettings,
}) {
  return showDialog<T>(
    context: context,
    routeSettings: routeSettings,
    barrierDismissible: barrierDismissible,
    builder: (context) => AppDialog(
      title: title,
      content: content,
      isEnableBack: isEnableBack,
      positiveButton: positiveButton,
      negativeButton: negativeButton,
      otherButton: otherButton,
    ),
  );
}
