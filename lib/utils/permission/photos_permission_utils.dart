import 'dart:io';

import 'package:flutter/material.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_utils.dart';

class PhotosPermissionUtils extends PermissionUtils {
  PhotosPermissionUtils(BuildContext context)
      : super(context, Permission.photos, Icons.photo_library, S.current.descPhotosPermission);

  @override
  Future<bool> checkPermission() {
    if (Platform.isAndroid) {
      return StoragePermissionUtils(context).checkPermission();
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
