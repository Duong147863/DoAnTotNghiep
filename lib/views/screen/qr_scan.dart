import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/shifts_model.dart';
import 'package:nloffice_hrm/models/timekeepings_model.dart';
import 'package:nloffice_hrm/view_models/time_attendance_view_model.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class QrScan extends StatefulWidget {
  Profiles user;
  Shifts? shift;
  QrScan({super.key, required this.user, this.shift});
  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  final controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );

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
          allowDuplicates: false,
          controller: controller,
          onDetect: (Barcode barcode, MobileScannerArguments? args) {
            DateFormat timeFormat = DateFormat("H:m:s");
            DateFormat dateFormat = DateFormat("dd/MM/yyyy");
            Provider.of<TimeKeepingViewModel>(context, listen: false)
                .checkin(Timekeepings(
              checkin: timeFormat.parse(barcode.rawValue!.split(' ').last),
              late: timeFormat.parse(barcode.rawValue!.split(' ').last),
              checkout: timeFormat.parse(barcode.rawValue!.split(' ').last),
              leavingSoon: timeFormat.parse(barcode.rawValue!.split(' ').last),
              shiftId: "OT",
              profileId: widget.user.profileId,
              date: dateFormat.parse(barcode.rawValue!.split(' ').first),
            ))
                .then((_) {
              controller.stop();
              Navigator.pop(context);
            });
          },
        ),
      ),
    );
  }
}
