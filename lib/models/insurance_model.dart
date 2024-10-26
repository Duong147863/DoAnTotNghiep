import 'dart:ffi';

class Insurance {
  Insurance({
    required this.profileId,
    required this.insuranceTypeName,
    required this.startTime,
    required this.endTime,
    required this.insurancePercent,
    required this.insuranceId,
  });
  String profileId;
  String insuranceTypeName;
  DateTime startTime;
  DateTime endTime;
  Double insurancePercent;
  String insuranceId;
  factory Insurance.fromJson(Map<String, dynamic> json) {
    return Insurance(
      profileId: json["profile_id"],
      insuranceTypeName: json["insurance_type_name"],
      startTime: json["start_time"],
      endTime: json["end_time"],
      insurancePercent: json["insurance_percent"],
      insuranceId: json[""],
    );
  }
    Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["profile_id"] = profileId;
    map["insurance_type_name"] = insuranceTypeName;
    map["start_time"] = startTime;
    map["end_time"] = endTime;
    map["insurance_percent"] = insurancePercent;
    map["insurance_id"] = insuranceId;
    return map;
  }
}
