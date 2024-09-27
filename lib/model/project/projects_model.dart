class Projects {
  Projects(
      {this.projectId,
      this.projectName,
      this.projectStatus,
      this.enterpriseId,
      this.departmentId});
  String? projectId;
  String? projectName;
  int? projectStatus;
  int? enterpriseId;
  String? departmentId;

  factory Projects.fromJson(Map<String, dynamic> json) {
    return Projects(
      projectId: json["project_id"],
      projectName: json["project_name"],
      projectStatus: json["project_status"],
      departmentId: json["department_id"],
      enterpriseId: json["enterprise_id"],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["project_id"] = projectId;
    map["profile_name"] = projectName;
    map["project_status"] = projectStatus;
    map["department_id"] = departmentId;
    map["enterprise_id"] = enterpriseId;
    return map;
  }
}
