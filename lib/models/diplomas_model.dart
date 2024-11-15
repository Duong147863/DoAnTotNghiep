import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

import 'package:intl/intl.dart';

class Diplomas {
  Diplomas(
      {required this.diplomaId,
      required this.diplomaName,
      required this.grantedBy,
      required this.licenseDate,
      required this.diplomaImage,
      required this.ranking,
      this.major,
      required this.modeOfStudy,
      required this.diplomaType,
      required this.profileId,
      this.isExpanded=false});

  String diplomaId;
  String diplomaName;
  String diplomaImage;
  String modeOfStudy;
  String ranking;
  DateTime licenseDate;
  String? major;
  String grantedBy;
  String diplomaType;
  String profileId;
  bool isExpanded;
  factory Diplomas.fromJson(Map<String, dynamic> json) {
    return Diplomas(
      diplomaId: json["diploma_id"],
      diplomaName: json["diploma_degree_name"],
      diplomaImage: json["diploma_image"],
      modeOfStudy: json["mode_of_study"],
      ranking: json["ranking"],
      licenseDate: DateFormat("dd-MM-yyyy").parse(json['license_date']),
      major: json["major"],
      grantedBy: json["granted_by"],
      diplomaType: json["diploma_type"],
      profileId: json["profile_id"],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["diploma_id"] = diplomaId;
    map["diploma_degree_name"] = diplomaName;
    map["diploma_image"] = diplomaImage;
    map["mode_of_study"] = modeOfStudy;
    map["ranking"] = ranking;
    map["license_date"] = DateFormat("dd-MM-yyyy").format(licenseDate);
    map["major"] = major;
    map["granted_by"] = grantedBy;
    map["diploma_type"] = diplomaType;
    map["profile_id"] = profileId;
    return map;
  }
}
