  class Tasks {
  Tasks({
     this.taskId,
    required this.taskName,
    required this.taskStatus,
    required this.taskContent,
  });
  int? taskId;
  String taskName;
  int taskStatus;
  String taskContent;
  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      taskId: json["task_id"],
      taskName: json["task_name"],
      taskStatus: int.parse(json["task_status"]),
      taskContent: json["task_content"],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["task_id"] = taskId;
    map["task_name"] = taskName;
    map["task_status"] = taskStatus;
    map["task_content"] = taskContent;
    return map;
  }
}
