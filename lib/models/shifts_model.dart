import 'dart:ffi';

class Shifts {
  Shifts(
      {required this.shiftId,
      required this.shiftName,
      required this.startTime,
      required this.endTime,
      this.status});

  String shiftId;
  DateTime startTime;
  DateTime endTime;
  String shiftName;
  Int8? status;

  factory Shifts.fromJson(Map<String, dynamic> json) => Shifts(
        shiftId: json["shift_id"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        shiftName: json["shift_name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "shift_id": shiftId,
        "shift_name": shiftName,
        "start_time": startTime,
        "end_time": endTime,
        "status": status
      };
}
