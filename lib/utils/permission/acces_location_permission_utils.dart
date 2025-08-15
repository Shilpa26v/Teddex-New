import 'dart:io';

import 'package:flutter/material.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_utils.dart';

class AccessLocationPermissionUtils extends PermissionUtils {
  AccessLocationPermissionUtils(BuildContext context)
      : super(context, Permission.accessMediaLocation, Icons.photo_library, S.current.descAccessLocationPermission);

  @override
  Future<bool> checkPermission() {
    if (Platform.isAndroid) {
      return AccessLocationPermissionUtils(context).checkPermission();
    }
    return super.checkPermission();
  }

  @override
  VoidCallback get onPermissionDenied => () {
        showAppDialog(
          context: context,
          title: S.current.titlePermissionDenied,
          content: S.current.descPermissionDenied(S.current.permissionPhotos),
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
