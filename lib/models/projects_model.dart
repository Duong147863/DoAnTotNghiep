class Projects {
  Projects(
      {required this.projectId,
      required this.projectName,
      required this.projectStatus,
      });
  String projectId;
  String projectName;
  String projectStatus;

  factory Projects.fromJson(Map<String, dynamic> json) {
    return Projects(
      projectId: json["project_id"],
      projectName: json["project_name"],
      projectStatus: json["project_status"],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["project_id"] = projectId;
    map["profile_name"] = projectName;
    map["project_status"] = projectStatus;
    return map;
  }
}
