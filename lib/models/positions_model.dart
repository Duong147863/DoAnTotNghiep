import 'dart:ffi';

class Positions {
  Positions({required this.positionId,required this.positionName});
  String positionId;
  String positionName;

  factory Positions.fromJson(Map<String,dynamic>json){
    return Positions(
      positionId: json["position_id"],
      positionName: json["position_name"],
    );
  }
  Map<String,dynamic> toJson(){
    final map= <String,dynamic>{};
    map["position_id"] = positionId;
    map["position_name"] = positionName;
    return map;
  }
}
