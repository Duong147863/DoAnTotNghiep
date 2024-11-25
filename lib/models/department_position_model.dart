class DepartmentPosition {
  DepartmentPosition({this.positionId, this.positionName, this.departmentID,this.departmentName});
  String? departmentID;
  String? departmentName;
  String? positionId;
  String? positionName;
 
   factory DepartmentPosition.fromJson(Map<String, dynamic> json) {
    return DepartmentPosition(
        departmentID: json["department_id"],
        departmentName: json["department_name"],
        positionId: json["position_id"],
        positionName: json["position_name"],
        );
  }
}