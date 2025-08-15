import 'package:flutter/material.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_utils.dart';

class CameraPermissionUtils extends PermissionUtils {


  CameraPermissionUtils(BuildContext context)
      : super(context, Permission.camera, Icons.camera_alt, S.current.descCameraPermission);

  @override
  VoidCallback get onPermissionDenied => () {
        showAppDialog(
          context: context,
          title: S.current.titlePermissionDenied,
          content: S.current.descPermissionDenied(S.current.permissionCamera),
          positiveButton: AppDialogButton(
            label: S.current.btnGoToSettings,
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
          ),
          negativeButton: AppDialogButton(
            label: S.current.btnCancel,
            onPressed: null,
          ),
        );
      };
}
