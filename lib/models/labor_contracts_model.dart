import 'dart:convert';
import 'dart:ffi';

import 'package:googleapis/gmail/v1.dart';
import 'package:intl/intl.dart';

class LaborContracts {
  LaborContracts({
    required this.image,
    required this.startTime,
    this.endTime,
    required this.laborContractId,
    this.isExpanded=false,
    required this.profiles
  });

  String image;
  DateTime startTime;
  DateTime? endTime;
  String laborContractId;
  String profiles;
  bool isExpanded;
  factory LaborContracts.fromJson(Map<String, dynamic> json) {
    return LaborContracts(
      image: json["image"],
      profiles: json["profile_id"],
      startTime: DateTime.parse(json['start_time']),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'])
          : null,
      laborContractId: json["labor_contract_id"],
    );
  }
  Map<String, dynamic> toJson() {
      final map = <String, dynamic>{};
    map["image"] = image;
    map["profile_id"] = profiles;
    map["start_time"] = DateFormat("dd-MM-yyyy").format(startTime);
     // Kiểm tra nếu endTime không phải là null, mới format
    if (endTime != null) {
      map["end_time"] = DateFormat("dd-MM-yyyy").format(endTime!);
    } else {
      map["end_time"] = null;  // Nếu endTime là null, gửi giá trị null
    }
    map["labor_contract_id"] = laborContractId;
    return map;
  }
}
