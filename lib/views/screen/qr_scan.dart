import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // version ^3.0.0-beta.4

class QrScan extends StatefulWidget {
  const QrScan({super.key});
  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  BarcodeCapture? barcode;

  final controller = MobileScannerController(
      formats: [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates,
      cameraResolution: Size(500, 500));

  bool isStarted = true;

  @override
  void initState() {
    super.initState();
    controller.start();
  }

  @override
  Future<void> dispose() async {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: (capture) {
        Future.delayed(Duration(milliseconds: 500)).then(
          (value) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              // print('QR ${barcode.rawValue}');
            }
          },
        );
        controller.stop();
      },
    );
  }
}
