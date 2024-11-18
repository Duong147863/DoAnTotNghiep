import 'package:intl/intl.dart';

class PayrollDetailsModel {
  PayrollDetailsModel({
    required this.salaryID,
    required this.month,
    this.bonus,
    this.minus,
    required this.sum,
  });
  String salaryID;
  double? bonus;
  double? minus;
  double sum;
  DateTime month;
  factory PayrollDetailsModel.fromJson(Map<String, dynamic> json) {
    return PayrollDetailsModel(
        salaryID: json["salary_id"],
        sum: json["sum"],
        minus: json["minus"],
        month: DateTime.parse(json['month']),
        bonus: json["bonus"]);
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["salary_id"] = salaryID;
    map["bonus"] = bonus;
    map["minus"] = minus;
    map["sum"] = sum;
    map["month"] = DateFormat("dd-MM-yyyy").format(month);
    return map;
  }
}
