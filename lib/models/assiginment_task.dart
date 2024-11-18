class AssiginmentTask {
  AssiginmentTask({
    this.assignmentId,
    required this.profileId,
    required this.projectId,
    this.taskId,
    this.isExpanded=false,
    this.profileName,
    this.taskName,
    this.taskStatus,
    this.taskContent,
    this.projectName
  });
  int? assignmentId;
  String profileId;
  String projectId;
  int? taskId;
  bool isExpanded;
  String? profileName;
  String? taskName;
  int? taskStatus;
  String? taskContent;
   String? projectName;
    factory AssiginmentTask.fromJson(Map<String, dynamic> json) {
    return AssiginmentTask(
      assignmentId: json["assignment_id"],
      profileId: json["profile_id"],
      projectId: json["project_id"],
      taskId: json["task_id"],
      taskName: json["task_name"],
      taskStatus: int.parse(json["task_status"]),
      taskContent: json["task_content"],
      profileName: json["profile_name"],
       projectName: json["project_name"],
    );
  }
}