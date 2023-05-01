import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../routers/navigator.dart';
import '../../utilities/components/arrow_back.dart';

class QrCodeScannerView extends StatefulWidget {
  const QrCodeScannerView({Key? key}) : super(key: key);

  @override
  State<QrCodeScannerView> createState() => _QrCodeScannerViewState();
}

class _QrCodeScannerViewState extends State<QrCodeScannerView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool check = true;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.resumeCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Expanded(
            child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(borderRadius: 15, borderColor: Colors.grey),
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          InkWell(
            onTap: () => CustomNavigator.pop(),
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: ArrowBack(color: Colors.white),
            ),
          ),
        ],
      )),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    setState(() {
      controller.resumeCamera();
    });
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null) {
        result = scanData;

        if (check) {
          check = false;
          CustomNavigator.pop(result: result);
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
