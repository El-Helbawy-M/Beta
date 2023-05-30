// ignore_for_file: prefer_final_fields

import 'dart:io';

import 'package:flutter_project_base/handlers/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHandler {
  ImagePicker _picker = ImagePicker();

  Future<File?> pickGalleryImage() async {
    // if (await PermissionHandler().checkGalleryPermission()) {
    var file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return File(file.path);
    } else {
      return null;
    }
    // } else {
    //   return null;
    // }
  }

  Future<File?> pickCameraImage() async {
    if (await PermissionHandler().checkCameraPermission()) {
      var file = await _picker.pickImage(source: ImageSource.camera);
      if (file != null) {
        return File(file.path);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
