class Shifts {
  Shifts(
      {required this.shiftId,
      required this.shiftName,
      required this.startTime,
      required this.endTime,});

  String shiftId;
  DateTime startTime;
  DateTime endTime;
  String shiftName;
  factory Shifts.fromJson(Map<String, dynamic> json) {
    return Shifts(
      shiftId: json["shift_id"],
      startTime: DateTime.parse(json["start_time"]),
      endTime: DateTime.parse(json["end_time"]),  
      shiftName: json["shift_name"],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["shift_id"] = shiftId;
    map["start_time"] = _formatTime(startTime);  
    map["end_time"] = _formatTime(endTime);   
    map["shift_name"] = shiftName;
    return map;
  }

 static String _formatTime(DateTime time) {
  return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
}
}
