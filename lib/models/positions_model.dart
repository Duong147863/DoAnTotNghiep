import 'dart:ffi';

class Positions {
  Positions({required this.positionId,required this.positionName,required this.departmentId});
  String positionId;
  String positionName;
  String departmentId;
  factory Positions.fromJson(Map<String,dynamic>json){
    return Positions(
      positionId: json["position_id"],
      positionName: json["position_name"],
      departmentId: json["department_id"],
    );
  }
  Map<String,dynamic> toJson(){
    final map= <String,dynamic>{};
    map["position_id"] = positionId;
    map["position_name"] = positionName;
    map["department_id"] = departmentId;
    return map;
  }
}
