// ignore_for_file: unused_import

import 'dart:developer';

import 'package:flutter_project_base/debug/log_printer.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  Future<bool> _checkPermissionIsGranted(Permission permission) async =>
      permission.isGranted;
  Future<bool> _checkPermission(Permission permission) async {
    if (!(await _checkPermissionIsGranted(permission))) {
      if (await permission.isPermanentlyDenied) {
        log("message1");
        // openAppSettings();
        return false;
      } else {
        PermissionStatus value = await permission.request();
        log(value.name);
        return await _checkPermissionIsGranted(permission);
      }
    } else {
      log("message3");
      return true;
    }
  }

  Future<bool> checkCameraPermission() async =>
      await _checkPermission(Permission.camera);

  Future<bool> checkBluetoothPermission() async =>
      await _checkPermission(Permission.bluetoothConnect);

  Future<bool> checkContactsPermission() async =>
      await _checkPermission(Permission.contacts);

  Future<bool> checkGalleryPermission() async =>
      await _checkPermission(Permission.photos);
}
