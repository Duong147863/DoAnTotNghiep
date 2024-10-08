class Departments // phòng ban
{
  Departments(
      {this.departmentID,
      this.departmentName,
      this.enterpriseID,
      this.departmentStatus});
  String? departmentID;
  String? departmentName;
  int? enterpriseID;
  int? departmentStatus;
  factory Departments.fromJson(Map<String, dynamic> json) {
    return Departments(
        departmentID: json["department_id"],
        departmentName: json["department_name"],
        enterpriseID: json["enterprise_id"],
        departmentStatus: json["department_status"]);
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["department_id"] = departmentID;
    map["department_name"] = departmentName;
    map["enterprise_id"] = enterpriseID;
    map["department_status"] = departmentStatus;
    return map;
  }
}
