import 'dart:ffi';

import 'package:flutter/foundation.dart';

class Relatives {
  Relatives(
      {this.profileId,
      this.relativesName,
      this.relativesPhone,
      this.relativesBirthday});
  int? profileId;
  String? relativesName;
  String? relativesPhone;
  DateTime? relativesBirthday;
  // factory Relatives.fromJson(Map<String, dynamic> json) => Relatives(
  //       profileId: json["profile_id"],
  //       relativesName: json["relatives_name"],
  //       relativesPhone: json["relatives_phone"],
  //       relativesBirthday: json["relatives_birthday"],
  //     );
  factory Relatives.fromJson(Map<String,dynamic>json){
    return Relatives(
      profileId: json["profile_id"],
      relativesName: json["relatives_name"],
      relativesPhone: json["relatives_phone"],
      relativesBirthday: json["relatives_birthday"]!= null 
          ? DateTime.parse(json["relatives_birthday"]) 
          : null,
    );
  }
  // Map<String, dynamic> toJson() => {
  //       "profile_id": profileId,
  //       "relatives_name": relativesName,
  //       "relatives_phone": relativesPhone,
  //       "relatives_birthday": relativesBirthday
  //     };
  Map<String,dynamic> toJson(){
    final map =<String,dynamic>{};
    map["profile_id"] = profileId;
    map["relatives_name"] = relativesName;
    map["relatives_phone"] = relativesPhone;
    map["relatives_birthday"] = relativesBirthday?.toIso8601String();
    return map;
  }
}
