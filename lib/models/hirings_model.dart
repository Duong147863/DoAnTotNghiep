import 'dart:convert';
import 'dart:ffi';

import 'package:intl/intl.dart';

class Hirings{
  Hirings({
    this.hiringProfileId,
    required this.profileName,
    required this.birthday,
    required this.placeOfBirth,
    required this.gender,
    required this.phone,
    this.email,
    required this.nation,
    required this.applyFor,
    required this.educationalLevel,
    required this.currentAddress,
    required this.hiringStatus,
    this.hiringProfileImage,
    required this.workExperience,
  });
  int? hiringProfileId;
  String profileName;
  DateTime birthday;
  String placeOfBirth;
  bool gender;
  String phone;
  String ? email;
  String nation;
  String applyFor;
  String educationalLevel;
  String currentAddress;
  int hiringStatus;
  String ? hiringProfileImage;
  String  workExperience;

   factory Hirings.fromJson(Map<String, dynamic> json) {
    return Hirings(
      hiringProfileId: json["hiring_profile_id"],
      profileName: json["profile_name"],
      birthday: DateTime.parse(json["birthday"]),
      placeOfBirth: json["place_of_birth"],
      gender: json["gender"],
      phone: json["phone"],
      email: json["email"],
      nation: json["nation"],
      applyFor: json["apply_for"],
      educationalLevel: json["educational_level"],
      currentAddress: json["current_address"],
      hiringStatus: json["hiring_status"],
      hiringProfileImage: json["hiring_profile_image"],
      workExperience: json["work_experience"],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["hiring_profile_id"] = hiringProfileId;
    map["profile_name"] = profileName;
    map["birthday"] = DateFormat("dd-MM-yyyy").format(birthday);
    map["place_of_birth"] = placeOfBirth;
    map["gender"] = gender;
    map["phone"] = phone;
    map["email"] = email;
    map["nation"] = nation;
    map["apply_for"] = applyFor;
    map["educational_level"] = educationalLevel;
    map["current_address"] = currentAddress;
    map["hiring_status"] = hiringStatus;
    map["hiring_profile_image"] = hiringProfileImage;
    map["work_experience"] = workExperience;
    return map;
  }
}
