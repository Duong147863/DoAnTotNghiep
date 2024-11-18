import 'dart:convert';
import 'dart:ffi';

import 'package:intl/intl.dart';

class LaborContracts {
  LaborContracts({
    required this.image,
    required this.startTime,
    this.endTime,
    required this.laborContractId,
    required this.enterpriseId,
    required this.departmentId,
    this.isExpanded=false
  });

  String image;
  DateTime startTime;
  DateTime? endTime;
  String laborContractId;
  int enterpriseId;
  String departmentId;
   bool isExpanded;
  factory LaborContracts.fromJson(Map<String, dynamic> json) {
    return LaborContracts(
      image: json["image"],
      startTime: DateFormat("dd-MM-yyyy").parse(json['start_time']),
      endTime: json['end_time'] != null
          ? DateFormat("dd-MM-yyyy").parse(json['end_time'])
          : null,
      laborContractId: json["labor_contract_id"],
      enterpriseId: json["enterprise_id"],
      departmentId: json["department_id"],
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["image"] = image;
    map["start_time"] = DateFormat("dd-MM-yyyy").format(startTime);
     // Kiểm tra nếu endTime không phải là null, mới format
    if (endTime != null) {
      map["end_time"] = DateFormat("dd-MM-yyyy").format(endTime!);
    } else {
      map["end_time"] = null;  // Nếu endTime là null, gửi giá trị null
    }
    map["labor_contract_id"] = laborContractId;
    map["enterprise_id"] = enterpriseId;
    map["department_id"] = departmentId;
    return map;
  }
}
