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
  // Shifts? shifts;
  QrScan({
    super.key,
    required this.user,
    // required this.shifts
  });
  @override
  _QrScanState createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  final controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );

  bool isStarted = true;
  Shifts? currentShift;

  @override
  void initState() {
    super.initState();
    getShiftAuto();
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
        .last); // kết quả sau khi lấy tgian vào trừ tgian bắt đầu ca
  }

  void getShiftAuto() async {
    await Provider.of<ShiftsViewModel>(context, listen: false).getAllShifts();
    List<Shifts> allShifts =
        Provider.of<ShiftsViewModel>(context, listen: false).listShifts;
    DateTime now = DateTime.now();
    // Duyệt qua tất cả các ca làm việc
    for (var shift in allShifts) {
      // Nếu không có ca nào khớp, chọn ca tiếp theo
      if (now.isAfter(shift.startTime) && now.isBefore(shift.endTime)) {
        setState(() {
          currentShift = shift;
        });
        break; // Nếu đã tìm thấy ca làm việc hiện tại, dừng lại
      }
    }

    // Nếu không có ca nào khớp, chọn ca tiếp theo
    if (currentShift == null) {
      for (var shift in allShifts) {
        if (now.isBefore(shift.startTime)) {
          setState(() {
            currentShift = shift;
          });
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Ca ${currentShift?.shiftName}",
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
                  checkin: DateFormat("H:m:s")
                      .parse(barcode.rawValue!.split(' ').last),
                  late: differentBetween(
                      //Tgian bắt đầu ca làm theo quy định
                      currentShift!.startTime,
                      DateFormat("H:m:s").parse(barcode.rawValue!
                          .split(' ')
                          .last)), // Tgian thực tế check in vào
                  checkout: DateFormat("H:m:s")
                      .parse(barcode.rawValue!.split(' ').last),
                  leavingSoon: differentBetween(
                      //Tgian out ca theo quy định
                      currentShift!.endTime,
                      //Tgian out thực tế
                      DateFormat("H:m:s")
                          .parse(barcode.rawValue!.split(' ').last)),
                  shiftId: currentShift!.shiftId,
                  profileId: widget.user.profileId,
                  date: DateFormat("dd/MM/yyyy")
                      .parse(barcode.rawValue!.split(' ').first),
                ))
                    .then((_) {
                  controller.stop();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Check in thành công!')),
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
