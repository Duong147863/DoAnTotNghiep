import 'dart:ffi';

import 'package:flutter/foundation.dart';

class Relatives {
  Relatives(
      {required this.profileId,
      required this.relativesName,
      required this.relativesPhone,
      required this.relativesBirthday,
      required this.relationship,
      required this.relativeId,
      required this.relativesNation,
      required this.relativesTempAddress,
      required this.relativesCurrentAddress,
      required this.relativeJob,
      });
  int relativeId;
  int profileId;
  String relativesName;
  String relationship;
  String relativesPhone;
  DateTime relativesBirthday;
  String relativesNation;
  String relativesTempAddress;
  int relativesCurrentAddress;
  String relativeJob;
  factory Relatives.fromJson(Map<String,dynamic>json){
    return Relatives(
      profileId: json["profile_id"],
      relativesName: json["relatives_name"],
      relativesPhone: json["relatives_phone"],
      // relativesBirthday: json["relatives_birthday"]!= null 
      //     ? DateTime.parse(json["relatives_birthday"]) 
      //     : null,
      relativesBirthday: json["relative_birthday"],
      relativeId: json["relative_id"],
      relationship: json["relationship"],
      relativesNation: json["relative_nation"],
      relativesTempAddress: json["relative_temp_address"],
      relativesCurrentAddress: json["relative_current_address"],
      relativeJob: json["relative_job"],
    );
  }
  Map<String,dynamic> toJson(){
    final map =<String,dynamic>{};
    map["profile_id"] = profileId;
    map["relatives_name"] = relativesName;
    map["relatives_phone"] = relativesPhone;
    map["relatives_birthday"] = relativesBirthday;
    map["relative_id"] = relativeId;
    map["relationship"] = relationship;
    map["relative_nation"] = relativesNation;
    map["relative_temp_address"] = relativesTempAddress;
    map["relative_current_address"] = relativesCurrentAddress;
    map["relative_job"] = relativeJob;
    return map;
  }
}
