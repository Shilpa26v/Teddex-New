import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/widgets/app_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_utils.dart';

class StoragePermissionUtils extends PermissionUtils {


  StoragePermissionUtils(BuildContext context)
      : super(context, Permission.storage, Icons.sd_storage, S.current.descStoragePermission);


  @override
  VoidCallback get onPermissionDenied => () {
        showAppDialog(
          context: context,
          title: S.current.titlePermissionDenied,
          content: S.current.descPermissionDenied(S.current.permissionStorage),
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
