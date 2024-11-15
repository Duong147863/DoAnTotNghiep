import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/timekeepings_model.dart';
import 'package:nloffice_hrm/view_models/time_attendance_view_model.dart';
import 'package:provider/provider.dart'; // version ^3.0.0-beta.4

class QrScan extends StatefulWidget {
  Profiles user;
  QrScan({super.key, required this.user});
  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  BarcodeCapture? barcode;

  final controller = MobileScannerController(
      formats: [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.noDuplicates,
      cameraResolution: Size(400, 400));

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
    return Center(
      child: Container(
        height: 350,
        width: 350,
        child: MobileScanner(
          controller: controller,
          onDetect: (capture) {
            Future.delayed(Duration(milliseconds: 500)).then(
              (value) {
                // final List<Barcode> barcodes = capture.barcodes;
                print(barcode);
                Provider.of<TimeKeepingViewModel>(context, listen: false)
                    .checkin(Timekeepings(
                  checkin: DateFormat("HH:mm:ss")
                      .parse(capture.barcodes.toString().trim()),
                  shiftId: 'CH',
                  profileId: widget.user.profileId,
                  date: DateFormat("yyyy-MM-dd")
                      .parse(capture.barcodes.toString().trim()),
                ));
              },
            );
            controller.stop();
          },
        ),
      ),
    );
  }
}
