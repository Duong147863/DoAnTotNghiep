import 'dart:ffi';

class Positions {
  Positions({this.positionId, this.positionName, this.enterpriseId});
  String? positionId;
  String? positionName;
  int? enterpriseId;

  factory Positions.fromJson(Map<String,dynamic>json){
    return Positions(
      positionId: json["position_id"],
      positionName: json["position_name"],
      enterpriseId: json["enterprise_id"],
    );
  }
  Map<String,dynamic> toJson(){
    final map= <String,dynamic>{};
    map["position_id"] = positionId;
    map["position_name"] = positionName;
    map["enterprise_id"] = enterpriseId;
    return map;
  }
}
