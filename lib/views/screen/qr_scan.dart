import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/shifts_model.dart';
import 'package:nloffice_hrm/models/timekeepings_model.dart';
import 'package:nloffice_hrm/view_models/shifts_view_model.dart';
import 'package:nloffice_hrm/view_models/time_attendance_view_model.dart';
import 'package:provider/provider.dart';

class QrScan extends StatefulWidget {
  Profiles user;
  Shifts currentShift;
  QrScan({super.key, required this.user, required this.currentShift});
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

  DateTime differentBetween(DateTime time1, DateTime time2) {
    Duration duration = Duration(
        hours: time2.hour,
        minutes: time2.minute,
        seconds: time2.second); // lấy thời gian bắt đầu ca làm
    return DateFormat("H:m:s").parse(time1
        .subtract(duration)
        .toString()
        .split(' ')
        .last); // kết quả sau khi lấy time1 trừ time2
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Ca ${widget.currentShift.shiftName}\n${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(widget.currentShift.startTime))} - ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(widget.currentShift.endTime))}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          Container(
            height: 350,
            width: 350,
            child: MobileScanner(
              allowDuplicates: false,
              controller: controller,
              onDetect: (Barcode barcode, MobileScannerArguments? args) {
                Provider.of<TimeKeepingViewModel>(context, listen: false)
                    .checkin(Timekeepings(
                  checkin: DateFormat("H:m:s") // Tgian thực tế check in vào
                      .parse(barcode.rawValue!.split(' ').last),
                  late: differentBetween(
                    DateFormat("H:m:s").parse(barcode.rawValue!
                        .split(' ')
                        .last), //Tgian bắt đầu ca làm theo quy định
                    widget.currentShift.startTime,
                  ),
                  checkout: DateFormat("H:m:s")
                      .parse(barcode.rawValue!.split(' ').last),
                  shiftId: widget.currentShift.shiftId,
                  profileId: widget.user.profileId,
                  date: DateFormat("dd/MM/yyyy")
                      .parse(barcode.rawValue!.split(' ').first),
                ))
                    .then((_) {
                  controller.stop();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Xin cảm ơn!')),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
