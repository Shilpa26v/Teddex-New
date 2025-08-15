import 'dart:io';

import 'package:teddex/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teddex/widgets/widgets.dart';

export 'camera_permission_utils.dart';
export 'contacts_permission_utils.dart';
export 'photos_permission_utils.dart';
export 'storage_permission_utils.dart';

abstract class PermissionUtils {
  final Permission permission;
  final BuildContext context;
  final IconData icon;
  final String description;

  PermissionUtils(this.context, this.permission, this.icon, this.description);

  Future<bool> get hasPermission => permission.isGranted;

  Future<bool> requestPermission() async {
    var isContinue = await showPermissionsDialog(
      context: context,
      description: description,
      icon: icon,
    );
    if (isContinue == true) {
      var result = await permission.request();
      Log.debug("reuest permission rewut..$result");
      if (result == PermissionStatus.granted || result == PermissionStatus.limited) {
        return true;
      } else if (result == PermissionStatus.permanentlyDenied) {
        onPermissionDenied();
      }
    }
    return false;
  }

  Future<bool> checkPermission() async {
    var status = await permission.request();

    Log.debug("status..$status");
    if (status == PermissionStatus.granted || (Platform.isIOS && status == PermissionStatus.limited)) {
      return true;
    } else if (status == PermissionStatus.permanentlyDenied || status == PermissionStatus.permanentlyDenied) {
      onPermissionDenied();
      return false;
    } else {
      return requestPermission();
    }
  }

  VoidCallback get onPermissionDenied;
}
