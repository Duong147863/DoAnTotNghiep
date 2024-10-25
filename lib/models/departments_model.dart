class Departments // phòng ban
{
  Departments({
    this.departmentID,
    this.departmentName,
  });
  String? departmentID;
  String? departmentName;
  factory Departments.fromJson(Map<String, dynamic> json) {
    return Departments(
        departmentID: json["department_id"],
        departmentName: json["department_name"]);
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["department_id"] = departmentID;
    map["department_name"] = departmentName;
    return map;
  }
}
