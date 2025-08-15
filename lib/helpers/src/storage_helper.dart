import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teddex/utils/permission/permission_utils.dart';

Future<String> cacheDirectory() async {
  final directory = await getTemporaryDirectory();
  return _checkAndCreateDir(directory);
}

Future<String> downloadDirectory() async {
  Directory? directory;

  if (Platform.isAndroid) {
    directory = Directory('/storage/emulated/0/Download');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  } else if (Platform.isIOS) {
    directory = await getApplicationDocumentsDirectory();
  }

  return _checkAndCreateDir(directory!);
}

String? getFileExtension(String fileName) {
  try {
    return ".${fileName.split('.').last}";
  } catch (e) {
    return null;
  }
}

Future<String> _checkAndCreateDir(Directory directory) async {
  bool hasExisted = await directory.exists();
  if (!hasExisted) directory = await directory.create();
  var downloadDir = Directory("${directory.path}${Platform.pathSeparator}Tedeex");
  if (!downloadDir.existsSync()) {
    await downloadDir.create(recursive: true);
  }
  return downloadDir.path;
}

Future<void> downloadFile(
    context, final String downloadLink, final String designCode, StreamController progressController) async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    int androidVersion = androidInfo.version.sdkInt;
    if (androidVersion < 32) {
      var isPermission = await StoragePermissionUtils(context).checkPermission();
      if (!isPermission) {
        return;
      }
    }
  }
  final saveDirectory = await downloadDirectory();

  try {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Download Started."), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 1)));
    await Dio().download(downloadLink,
        "$saveDirectory/$designCode${"_${DateTime.now().millisecondsSinceEpoch}"}.${getFileExtension(downloadLink)}",
        onReceiveProgress: (received, total) async {
      if (total != -1) {
        progressController.sink.add((received / total * 100).toInt().toDouble());

        if ((received / total * 100).toDouble() == 100.toDouble()) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("File Downloaded"), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 1)));
        }
      }
    });
  } on DioError catch (e) {
    progressController.close();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to download!"), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 1)));
  } catch (e) {
    progressController.close();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to download!"), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 1)));
  }

  // await FlutterDownloader.enqueue(
  //   url: downloadLink,
  //   savedDir: saveDirectory,
  //   saveInPublicStorage: false,
  //   showNotification: true,
  //   openFileFromNotification: true,
  // );
}
