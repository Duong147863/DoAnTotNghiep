import 'dart:ui';

import 'package:intl/intl.dart';

class Decisions {
  Decisions(
      {required this.decisionId,
      required this.decisionContent,
      required this.decisionName,
      required this.assignDate,
      this.decisionImage,
      required this.decisionStatus,
      this.profileName,
      this.profileId});

  String decisionId;
  String decisionName;
  DateTime assignDate;
  int decisionStatus;
  String? profileId;
  String? decisionImage;
  String decisionContent;
  String? profileName;

  factory Decisions.fromJson(Map<String, dynamic> json) {
    return Decisions(
        decisionId: json["decision_id"],
        profileName: json["profile_name"],
        decisionContent: json["decision_content"],
        decisionName: json["decision_name"],
        assignDate: DateTime.parse(json["assign_date"]),
        decisionImage: json["decision_image"],
        decisionStatus: json['decision_status'],
        profileId: json['profile_id']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["decision_id"] = decisionId;
    map["decision_content"] = decisionContent;
    map["decision_name"] = decisionName;
    map["assign_date"] = DateFormat("dd-MM-yyyy").format(assignDate);
    map["decision_image"] = decisionImage;
    map["decision_status"] = decisionStatus;
    map["profile_id"] = profileId;
    return map;
  }
}
