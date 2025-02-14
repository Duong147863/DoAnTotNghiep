import 'dart:convert';
import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';

class Absents {
  Absents({
    this.ID,
    this.reason,
    required this.from,
    this.to,
    this.daysOff,
    required this.profileID,
    this.status = -1,
    this.isExpanded = false,
  });

  DateTime from;
  String? reason;
  DateTime? to;
  int status;
  String profileID;
  double? daysOff;
  int? ID;
  bool isExpanded;

  factory Absents.fromJson(Map<String, dynamic> json) {
    return Absents(
      ID: json["ID"],
      reason: json["reason"],
      to:
          json['to'] != null ? DateTime.parse(json['to']) : null,
      status: json["status"],
      profileID: json["profile_id"],
      daysOff: json["days_off"] != null
          ? (json["days_off"] is int
              ? (json["days_off"] as int).toDouble()
              : json["days_off"] as double)
          : null,
      from: DateTime.parse(json['from']),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["from"] = DateFormat("dd-MM-yyyy").format(from);
    map["reason"] = reason;
     if (to != null) {
      map["to"] = DateFormat("dd-MM-yyyy").format(to!);
    } else {
      map["to"] = null;
    }
    map["status"] = status;
    map["profile_id"] = profileID;
    map["days_off"] = daysOff;
    map["ID"] = ID;
    return map;
  }
}
