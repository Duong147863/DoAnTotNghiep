import 'dart:convert';
import 'dart:ffi';
class LaborContracts{
  LaborContracts({
    required this.profileId,
    required this.image,
    required this.startTime,
    this.endTime,
    required this.laborContractId,
    required this.enterpriseId,
    required this.departmentId,
  });

  String profileId;
  String image;
  DateTime startTime;
  DateTime ? endTime;
  String laborContractId;
  int enterpriseId;
  String departmentId;

  factory LaborContracts.fromJson(Map<String, dynamic> json) {
    return LaborContracts(
      profileId: json["profile_id"],
      image: json["image"],
      startTime: json["start_time"],
      endTime: json["end_time"],
      laborContractId: json["labor_contract_id"],
      enterpriseId: json["enterprise_id"],
      departmentId: json["department_id"],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["profile_id"] = profileId;
    map["image"] = image;
    map["start_time"] = startTime;
    map["end_time"] = endTime;
    map["labor_contract_id"] = laborContractId;
    map["enterprise_id"] = enterpriseId;
    map["department_id"] = departmentId;
    return map;
  }
}