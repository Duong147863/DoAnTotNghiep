import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Relatives {
  Relatives(
      {required this.profileId,
      required this.relativesName,
      required this.relativesPhone,
      required this.relativesBirthday,
      required this.relationship,
      this.relativeId,
      required this.relativesNation,
      required this.relativesTempAddress,
      required this.relativesCurrentAddress,
      required this.relativeJob,
      });
  int? relativeId;
  String profileId;
  String relativesName;
  String relationship;
  String relativesPhone;
  DateTime relativesBirthday;
  String relativesNation;
  String relativesTempAddress;
  String relativesCurrentAddress;
  String relativeJob;
  factory Relatives.fromJson(Map<String,dynamic>json){
    return Relatives(
      profileId: json["profile_id"],
      relativesName: json["relative_name"],
      relativesPhone: json["relative_phone"],
      relativesBirthday: DateFormat("dd-MM-yyyy").parse(json['relative_birthday']),
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
    map["relative_name"] = relativesName;
    map["relative_phone"] = relativesPhone;
    map["relative_birthday"] = relativesBirthday.toIso8601String();
    map["relationship"] = relationship;
    map["relative_nation"] = relativesNation;
    map["relative_temp_address"] = relativesTempAddress;
    map["relative_current_address"] = relativesCurrentAddress;
    map["relative_job"] = relativeJob;
    return map;
  }
}
