import 'package:flutter/material.dart';

class Profiles {
  Profiles({
    this.profileId,
    required this.profileName,
    this.profileStatus = 0,
    required this.birthday,
    required this.place_of_birth,
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
    required this.permission,
    this.labor_contract_id,
    this.marriage = 0,
    required this.temporary_address,
    required this.current_address,
    // required this.profile_image
  });

  String? profileId;
  String profileName;
  DateTime birthday;
  String place_of_birth;
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
  //Thêm mới
  int permission;
  int marriage;
  String temporary_address;
  String current_address;
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
        place_of_birth: json["place_of_birth"],
        nation: json["nation"],
        marriage: json["marriage"],
        temporary_address: json["temporary_address"],
        current_address: json["current_address"],
        permission: json["permission"],
        // profile_image: json["profile_image "]
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
    map["place_of_birth"] = place_of_birth;
    map["nation"] = nation;
    map["marriage"] = marriage;
    map["temporary_address"] = temporary_address;
    map["current_address"] = current_address;
    map["permission"] = permission;
    // map["profile_image"] = profile_image;
    return map;
  }
}
