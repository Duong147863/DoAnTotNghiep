import 'package:flutter/material.dart';

class Profiles {
  Profiles(
      {required this.profileName,
      this.profileStatus = 0,
      required this.idLicenseDay,
      required this.identifiNum,
      this.gender = false,
      required this.phone,
      this.email,
      this.departmentId,
      this.profileId,
      this.salaryId,
      required this.birthday,
       required this.password,
      this.positionId,
      this.diplomaId});

  String profileName;
  int profileStatus;
  String identifiNum;
  DateTime idLicenseDay;
  bool gender;
  String phone;
  String? email;
  String? departmentId;
  String? profileId;
  String? salaryId;
  DateTime birthday;
  String? positionId;
  String? diplomaId;
  String password;

  factory Profiles.fromJson(Map<String, dynamic> json) {
    return Profiles(
      profileName: json["profile_name"],
      profileStatus: json["profile_status"],
      identifiNum: json["identify_num"],
      idLicenseDay: json["id_expire_day"],
      gender: json["gender"],
      phone: json["phone"],
      email: json["email"],
      password: json["password"],
      departmentId: json["department_id"],
      profileId: json["profile_id"],
      salaryId: json["salary_id"],
      birthday: json["birthday"],
      positionId: json["position_id"],
      diplomaId: json["diploma_id"],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["profile_name"] = profileName;
    map["profile_status"] = profileStatus;
    map["identify_num"] = identifiNum;
    map["id_license_day"] = idLicenseDay;
    map["gender"] = gender;
    map["phone"] = phone;
    map["email"] = email;
    map["department_id"] = departmentId;
    map["profile_id"] = profileId;
    map["salary_id"] = salaryId;
    map["birthday"] = birthday;
    map["position_id"] = positionId;
    map["diploma_id"] = positionId;
    return map;
  }
}
