import 'package:flutter/foundation.dart';
import 'package:nloffice_hrm/models/absents_model.dart';

class Assignments {
  Assignments({
    this.assignmentId,
    required this.profileId,
    required this.projectId,
    this.taskId,
  });

  int? assignmentId;
  String profileId;
  String projectId;
  int? taskId;

  factory Assignments.fromJson(Map<String, dynamic> json) {
    return Assignments(
      assignmentId: json["assignment_id"],
      profileId: json["	profile_id"],
      projectId: json["project_id "],
      taskId: json["task_id"],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["assignment_id"] = assignmentId;
    map["profile_id"] = profileId;
    map["project_id"] = projectId;
    map["task_id"] = taskId;
    return map;
  }
}
