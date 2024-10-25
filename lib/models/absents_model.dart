import 'dart:convert';
import 'dart:ffi';

class Absents {
  Absents(
      {this.ID,
      required this.from,
      this.to,
      this.daysOff,
      required this.profileID,
      this.status});

  int? ID;
  DateTime from;
  DateTime? to;
  double? daysOff;
  String? profileID;
  Int8? status;

  factory Absents.fromJson(Map<String, dynamic> json) => Absents(
      ID: json["ID"],
      from: json["from"],
      to: json["to"],
      daysOff: json["days_off"],
      profileID: json["enterprise_id"],
      status: json["status"]);

  Map<String, dynamic> toJson() => {
        "ID": ID,
        "from": from,
        "to": to,
        "days_off": daysOff,
        "enterprise_id": profileID,
        "status": status
      };
}
