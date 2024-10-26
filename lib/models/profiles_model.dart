import 'package:flutter/material.dart';

class Profiles {
  Profiles({
    required this.profileId,
    required this.profileName,
    this.profileStatus = 1,
    required this.birthday,
    required this.placeOfBirth,
    required this.identifiNum,
    required this.idLicenseDay,
    this.gender = false,
    required this.phone,
    this.email,
    required this.nation,
    this.departmentId,
    this.salaryId,
    this.positionId,
    required this.password,
    this.labor_contract_id,
    this.marriage = false,
    required this.temporaryAddress,
    required this.currentAddress,
    // required this.profile_image
  });

  String profileId;
  String profileName;
  DateTime birthday;
  String placeOfBirth;
  String identifiNum;
  DateTime idLicenseDay;
  bool gender;
  String phone;
  String? email;
  String nation;
  String? departmentId;
  String? salaryId;
  String? positionId;
  String password;
  int profileStatus;
  bool marriage;
  String temporaryAddress;
  String currentAddress;
  String? labor_contract_id;
  // String profile_image;

  factory Profiles.fromJson(Map<String, dynamic> json) {
    return Profiles(
      profileName: json["profile_name"],
      profileStatus: json["profile_status"],
      identifiNum: json["identify_num"],
      idLicenseDay: DateTime.parse(json['idLicenseDay']),
      gender: json["gender"],
      phone: json["phone"],
      email: json["email"],
      password: json["password"],
      departmentId: json["department_id"],
      profileId: json["profile_id"],
      salaryId: json["salary_id"],
      birthday: DateTime.parse(json['birthday']),
      positionId: json["position_id"],
      placeOfBirth: json["place_of_birth"],
      nation: json["nation"],
      marriage: json["marriage"],
      temporaryAddress: json["temporary_address"],
      currentAddress: json["current_address"],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["profile_name"] = profileName;
    map["profile_status"] = profileStatus;
    map["identify_num"] = identifiNum;
    map["id_license_day"] = idLicenseDay.toIso8601String();
    map["gender"] = gender;
    map["phone"] = phone;
    map["email"] = email;
    map["password"] = password;
    map["department_id"] = departmentId;
    map["profile_id"] = profileId;
    map["salary_id"] = salaryId;
    map["birthday"] = birthday.toIso8601String();
    map["position_id"] = positionId;
    map["place_of_birth"] = placeOfBirth;
    map["nation"] = nation;
    map["marriage"] = marriage;
    map["temporary_address"] = temporaryAddress;
    map["current_address"] = currentAddress;
    map["profile_image"] = profileId;
    return map;
  }
}
