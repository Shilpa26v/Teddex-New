import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:image_picker/image_picker.dart';
import 'package:layout/layout.dart';
import 'package:path/path.dart' as path;
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/utils/permission/permission_utils.dart';
import 'package:teddex/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePicker {
  image_picker.ImageSource? imageSource;

  ImagePicker({this.imageSource});

  Future<XFile?> pickImage(BuildContext context, {bool hasRemoveOption = false, VoidCallback? onRemove}) async {
    try {
      imageSource ??= await _ImagePickerDialog.show(
        context: context,
        hasRemoveOption: hasRemoveOption,
        onRemove: onRemove,
      );
      if (imageSource == null) return null;
      switch (imageSource!) {
        case ImageSource.camera:
          var cameraPermission = await CameraPermissionUtils(context).checkPermission();
          if (!cameraPermission) return null;
          break;
        case ImageSource.gallery:
          var photosPermission = await Permission.photos.request();
          if (photosPermission.isPermanentlyDenied) {
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
            return null;
          }
          break;
      }
      var pickedImage = await imageSource?.also((it) async {
        image_picker.XFile? pickedImage =
        await image_picker.ImagePicker().pickImage(source: it, imageQuality: 80);
        return pickedImage;
      });
      if (pickedImage != null) {
        var compressedImage = await _compressFile(File(pickedImage.path));
        return compressedImage;
      }
    } on Exception catch (exception) {
      debugPrint("ImagePicker :: pickImage -> $exception");
    }
    return null;
  }

  Future<List<File>?> pickMultipleImage(BuildContext context) async {
    try {
      var photosPermission = await PhotosPermissionUtils(context).checkPermission();
      if (!photosPermission) return null;
      var listPickedImage = await imageSource?.also((it) async {
        List<image_picker.XFile>? listPickedImage = await image_picker.ImagePicker().pickMultiImage(imageQuality: 80);
        return listPickedImage;
      });
      if (listPickedImage != null) {
        List<File> listCompressedImage = [];
        for (var pickedImage in listPickedImage) {
          var compressedImage = await _compressFile(File(pickedImage.path));
          if (compressedImage != null) listCompressedImage.add(File(compressedImage.path));        }
        return listCompressedImage;
      }
    } on Exception catch (exception) {
      debugPrint("ImagePicker :: pickMultipleImage -> $exception");
    }
    return null;
  }

  Future<XFile?> _compressFile(File file) async {
    try {
      final extension = path.extension(file.path);
      CompressFormat compressFormat =
      extension.toLowerCase() == ".png" ? CompressFormat.png : CompressFormat.jpeg;
      final targetPath =
          "${await cacheDirectory()}${Platform.pathSeparator}${path.basenameWithoutExtension(file.path)}_compress${path.extension(file.path)}";
      XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 80,
        format: compressFormat,
      );
      return result;
    } on Exception catch (exception) {
      debugPrint("ImagePicker :: _compressFile -> $exception");
    }
    return null;
  }
}

class _ImagePickerDialog extends StatelessWidget {
  final bool hasRemoveOption;
  final VoidCallback? onRemove;

  const _ImagePickerDialog({Key? key, this.hasRemoveOption = false, this.onRemove}) : super(key: key);

  static Future<image_picker.ImageSource?> show({
    required BuildContext context,
    bool hasRemoveOption = false,
    VoidCallback? onRemove,
  }) {
    return showDialog<image_picker.ImageSource>(
      context: context,
      builder: (context) => _ImagePickerDialog(hasRemoveOption: hasRemoveOption, onRemove: onRemove),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Dialog(
      clipBehavior: Clip.hardEdge,
      backgroundColor: AppColor.white,
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Scrollable(
        viewportBuilder: (BuildContext context, ViewportOffset position) => Container(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 8),
          constraints: const BoxConstraints(maxWidth: AdaptiveBreakpoints.small),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonText.medium(S.of(context).selectImageSource, size: 18, textAlign: TextAlign.center),
              const Gap(16),
              ListTile(
                onTap: () => Navigator.of(context).pop(image_picker.ImageSource.gallery),
                title: CommonText.semiBold(S.current.sourceGallery, size: 16),
                leading: const Icon(Icons.photo, color: AppColor.primaryDark),
                horizontalTitleGap: 0,
              ),
              ListTile(
                onTap: () => Navigator.of(context).pop(image_picker.ImageSource.camera),
                title: CommonText.semiBold(S.current.sourceCamera, size: 16),
                leading: const Icon(Icons.camera, color: AppColor.primaryDark),
                horizontalTitleGap: 0,
              ),
              if (hasRemoveOption)
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    onRemove?.call();
                  },
                  title: CommonText.semiBold(S.current.btnRemove, size: 16),
                  leading: const Icon(Icons.close, color: AppColor.primaryDark),
                  horizontalTitleGap: 0,
                ),
              InkWell(
                onTap: Navigator.of(context).pop,
                splashColor: colorScheme.error.withOpacity(0.1),
                highlightColor: colorScheme.error.withOpacity(0.05),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
                  child: Text(
                    S.of(context).btnCancel,
                    style: textTheme.labelLarge?.copyWith(color: colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
