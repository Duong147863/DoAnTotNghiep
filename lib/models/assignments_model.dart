class Assignments {
  Assignments({
    this.assignmentId,
    this.profileId,
    this.projectId,
    this.taskId,
  });

  String? assignmentId;
  String? profileId;
  String? projectId;
  int? taskId;

  factory Assignments.fromJson(Map<String, dynamic> json) => Assignments(
        assignmentId: json["assignment_id"],
        profileId: json["profile_id"],
        projectId: json["project_id"],
        taskId: json["task_id"],
      );

  Map<String, dynamic> toJson() => {
        "assignment_id": assignmentId,
        "profile_id": profileId,
        "project_id": projectId,
        "task_id": taskId,
      };
}
