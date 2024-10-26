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
  factory Shifts.fromJson(Map<String, dynamic> json) {
    return Shifts(
      shiftId: json["shift_id"],
      startTime: json["start_time"],
      endTime: json["end_time"],
      shiftName: json["shift_name"],
      status: json["status"],
    );
  }
   Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["shift_id"] = shiftId;
    map["start_time"] = startTime;
    map["end_time"] = endTime;
    map["shift_name"] = shiftName;
    map["status"] = status;
    return map;
  }
}
