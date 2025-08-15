import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:teddex/generated/l10n.dart';

class PermissionDialog extends StatelessWidget {
  final String description;
  final IconData icon;

  const PermissionDialog({Key? key, required this.description, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dialogTheme = theme.dialogTheme;
    final colorScheme = theme.colorScheme;

    return Dialog(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        constraints: const BoxConstraints(maxWidth: AdaptiveBreakpoints.small),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              color: colorScheme.primary,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 40),
                child: Icon(icon, size: 48, color: colorScheme.onPrimary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              child: Text(description, style: dialogTheme.contentTextStyle, textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(S.of(context).btnNotNow),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(S.of(context).btnContinue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<T?> showPermissionsDialog<T>({
  required BuildContext context,
  required String description,
  required IconData icon,
  RouteSettings? routeSettings,
}) {
  return showDialog<T>(
    context: context,
    routeSettings: routeSettings,
    barrierDismissible: false,
    builder: (context) => PermissionDialog(icon: icon, description: description),
  );
}
