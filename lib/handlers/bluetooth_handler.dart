import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_project_base/handlers/permission_handler.dart';

class BluetoothHandler {
  FlutterBluePlus package = FlutterBluePlus.instance;

  /// # BluetoothHandler
  /// ### Run function
  /// With this function you can run the service you want, <br>
  /// you need to pass `BluetoothServices` opject to run this service <br>
  dynamic run(BluetoothServices service) async {
    if (await PermissionHandler().checkBluetoothPermission()) {
      switch (service) {
        case BluetoothServices.getConnectedDevices:
          return await _getConnectedDevices();
        case BluetoothServices.isOpen:
          return await package.isOn;
        default:
          return false;
      }
    }
    return false;
  }

  Future<List<BluetoothDevice>> _getConnectedDevices() async {
    if (Platform.isAndroid) {
      return await package.bondedDevices;
    }
    return await package.connectedDevices;
  }
}

enum BluetoothServices { getConnectedDevices, isOpen }
