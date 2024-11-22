import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Profiles {
  Profiles(
      {required this.profileId,
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
      this.password,
      this.laborContractId,
      this.marriage = false,
      required this.temporaryAddress,
      required this.currentAddress,
      required this.roleID,
      this.profileImage});

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
  String? laborContractId;
  String? password;
  int profileStatus;
  bool marriage;
  String temporaryAddress;
  String currentAddress;
  int roleID;
  String? profileImage;

  factory Profiles.fromJson(Map<String, dynamic> json) {
    return Profiles(
      profileId: json["profile_id"],
      profileName: json["profile_name"],
      profileStatus: json["profile_status"],
      identifiNum: json["identify_num"],
      idLicenseDay: DateTime.parse(
        json['id_license_day'],
      ),
      gender: json["gender"],
      phone: json["phone"],
      email: json["email"],
      password: json["password"],
      birthday: DateTime.parse(json['birthday']),
      placeOfBirth: json["place_of_birth"],
      nation: json["nation"],
      marriage: json["marriage"],
      temporaryAddress: json["temporary_address"],
      currentAddress: json["current_address"],
      roleID: json["role_id"],
      departmentId: json["department_id"],
      salaryId: json["salary_id"],
      positionId: json["position_id"],
      laborContractId: json["labor_contract_id"],
      profileImage: json["profile_image"],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["profile_name"] = profileName;
    map["profile_status"] = profileStatus;
    map["identify_num"] = identifiNum;
    map["id_license_day"] = DateFormat("dd-MM-yyyy").format(idLicenseDay);
    map["gender"] = gender;
    map["phone"] = phone;
    map["email"] = email;
    map["password"] = password;
    map["department_id"] = departmentId;
    map["profile_id"] = profileId;
    map["salary_id"] = salaryId;
    map["birthday"] = DateFormat("dd-MM-yyyy").format(birthday);
    map["position_id"] = positionId;
    map["place_of_birth"] = placeOfBirth;
    map["nation"] = nation;
    map["marriage"] = marriage;
    map["temporary_address"] = temporaryAddress;
    map["current_address"] = currentAddress;
    map["profile_image"] = profileImage;
    map["role_id"] = roleID;
    map["labor_contract_id"] = laborContractId;
    return map;
  }
}
