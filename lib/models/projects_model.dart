class Projects {
  Projects(
      {required this.projectId,
      required this.projectName,
      this.projectStatus=0,
      this.isExpanded=false
      });
  String projectId;
  String projectName;
  int projectStatus;
   bool isExpanded;
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
    map["project_name"] = projectName;
    map["project_status"] = projectStatus;
    return map;
  }
}
