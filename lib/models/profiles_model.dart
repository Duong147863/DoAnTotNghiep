import 'package:flutter/foundation.dart';

class Profiles {
  Profiles(
      {this.profileName,
      this.profileStatus = 0,
      this.idExpireDay,
      this.identifiNum,
      this.gender,
      this.phone,
      this.email,
      this.departmentId,
      this.enterpriseId,
      this.profileId,
      this.salaryId,
      this.birthday,
      this.positionId,
      this.diplomaId});
  String? profileName;
  int profileStatus;
  String? identifiNum;
  DateTime? idExpireDay;
  int? gender;
  String? phone;
  String? email;
  String? departmentId;
  int? enterpriseId;
  int? profileId;
  String? salaryId;
  DateTime? birthday;
  String? positionId;
  String? diplomaId;

  factory Profiles.fromJson(Map<String, dynamic> json) {
    return Profiles(
      profileName: json["profile_name"],
      profileStatus: json["profile_status"],
      identifiNum: json["identify_num"],
      idExpireDay: json["id_expire_day"] != null
          ? DateTime.parse(json["id_expire_day"])
          : null,
      gender: json["gender"],
      phone: json["phone"],
      email: json["email"],
      departmentId: json["department_id"],
      enterpriseId: json["enterprise_id"],
      profileId: json["profile_id"],
      salaryId: json["salary_id"],
      birthday:
          json["birthday"] != null ? DateTime.parse(json["birthday"]) : null,
      positionId: json["position_id"],
      diplomaId: json["diploma_id"],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["profile_name"] = profileName;
    map["profile_status"] = profileStatus;
    map["identify_num"] = identifiNum;
    map["id_expire_day"] = idExpireDay?.toIso8601String();
    map["gender"] = gender;
    map["phone"] = phone;
    map["email"] = email;
    map["department_id"] = departmentId;
    map["enterprise_id"] = enterpriseId;
    map["profile_id"] = profileId;
    map["salary_id"] = salaryId;
    map["birthday"] = birthday?.toIso8601String();
    map["position_id"] = positionId;
    map["diploma_id"] = positionId;
    return map;
  }

  void deactivate() {
    profileStatus = 0;
  }
}
