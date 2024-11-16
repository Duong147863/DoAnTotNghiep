import 'dart:async';

import 'package:intl/intl.dart';

class Timekeepings {
  Timekeepings({
    this.timekeepingId,
    required this.checkin,
    this.checkout,
    required this.shiftId,
    required this.profileId,
    this.late,
    required this.date,
    this.leavingSoon,
    this.status = 0,
  });
  int? timekeepingId;
  DateTime checkin;
  DateTime? checkout;
  String shiftId;
  String profileId;
  DateTime? late;
  DateTime date;
  DateTime? leavingSoon;
  int status;
  factory Timekeepings.fromJson(Map<String, dynamic> json) {
    return Timekeepings(
      timekeepingId: json["timekeeping_id"],
      checkin: json["checkin"],
      checkout: json["checkout"],
      shiftId: json["shift_id"],
      profileId: json["profile_id"],
      late: json["late"],
      date: json["date"],
      leavingSoon: json["leaving_soon"],
      status: json["status"],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["timekeeping_id"] = timekeepingId;
    map["checkin"] = _formatTime(checkin);
    map["checkout"] = _formatTime(checkout!);
    map["shift_id"] = shiftId;
    map["profile_id"] = profileId;
    map["late"] = _formatTime(late!);
    map["date"] = DateFormat("yyyy-MM-dd").format(date);
    map["leaving_soon"] = _formatTime(leavingSoon!);
    map["status"] = status;
    return map;
  }

  static String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute..toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  }
}
