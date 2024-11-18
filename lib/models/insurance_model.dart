import 'dart:ffi';

import 'package:intl/intl.dart';

class Insurance {
  Insurance({
    required this.profileId,
    required this.insuranceTypeName,
    required this.startTime,
    required this.endTime,
    required this.insurancePercent,
    required this.insuranceId,
    this.isExpanded = false
  });
  String profileId;
  String insuranceTypeName;
  DateTime startTime;
  DateTime endTime;
  double insurancePercent;
  String insuranceId;
   bool isExpanded;
  factory Insurance.fromJson(Map<String, dynamic> json) {
    return Insurance(
      profileId: json["profile_id"],
      insuranceTypeName: json["insurance_type_name"],
      startTime: DateTime.parse(json['start_time']),
      endTime:DateTime.parse(json['end_time']),
      insurancePercent: (json["insurance_percent"] is int)
          ? (json["insurance_percent"] as int).toDouble()
          : json["insurance_percent"] as double,
      insuranceId: json["insurance_id"],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["profile_id"] = profileId;
    map["insurance_type_name"] = insuranceTypeName;
    map["start_time"] = DateFormat("dd-MM-yyyy").format(startTime);
    map["end_time"] = DateFormat("dd-MM-yyyy").format(endTime);
    map["insurance_percent"] = insurancePercent;
    map["insurance_id"] = insuranceId;
    return map;
  }
}
