import 'dart:convert';
import 'dart:ffi';

class Absents {
  Absents({
    this.ID,
    this.reason,
    required this.from,
    this.to,
    this.daysOff,
    required this.profileID,
    this.status = -1,
  });

  DateTime from;
  String? reason;
  DateTime? to;
  int status;
  String profileID;
  double? daysOff;
  int? ID;

  factory Absents.fromJson(Map<String, dynamic> json) {
    return Absents(
      ID: json["ID"],
      reason: json["reason"],
      to: json["to"],
      status: json["status"],
      profileID: json["profile_id"],
      daysOff: json["days_Off"],
      from: json["from"],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["from"] = from;
    map["reason"] = reason;
    map["to"] = to;
    map["status"] = status;
    map["profile_id"] = profileID;
    map["days_Off"] = daysOff;
    map["ID"] = ID;
    return map;
  }
}
