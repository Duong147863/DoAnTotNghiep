import 'dart:ui';

class Decisions {
  Decisions(
      {required this.decisionId,
      required this.decisionContent,
      required this.decisionName,
      required this.assignDate,
      required this.decisionImage,
      this.profileId});

  String decisionId;
  String decisionContent;
  String decisionName;
  DateTime assignDate;
  Image decisionImage;
  String? profileId;

  factory Decisions.fromJson(Map<String, dynamic> json) => Decisions(
      decisionId: json["decision_id"],
      decisionContent: json["decision_content"],
      decisionName: json["decision_name"],
      assignDate: json["assign_date"],
      decisionImage: json["decision_image"]);

  Map<String, dynamic> toJson() => {
        "decision_id": decisionId,
        "decision_content": decisionContent,
        "decision_name": decisionName,
        "assign_date": assignDate,
        "decision_image": decisionImage
      };
}
