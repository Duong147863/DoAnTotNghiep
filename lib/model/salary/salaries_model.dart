class Salaries {
  Salaries(
      {this.salaryId,
      this.salaryName,
      this.salary,
      this.allowance,
      this.enterpriseId,
      this.status});
  // int? salaryId;
  String? salaryId;
  String? salaryName;
  double? salary; //hệ số lương
  double? allowance; //hệ số phụ cấp
  int? enterpriseId;
  int? status;
  factory Salaries.fromJson(Map<String, dynamic> json) {
    return Salaries(
        salaryId: json["salary_id"],
        salaryName: json["salary_name"],
         salary: (json["salary"] is int) ? (json["salary"] as int).toDouble() : json["salary"],
      allowance: (json["allowances"] is int) ? (json["allowances"] as int).toDouble() : json["allowances"],
        enterpriseId: json["enterprise_id "],
        status: json["salary_status"]);
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["salary_id"] = salaryId;
    map["salary_name"] = salaryName;
    map["salary"] = salary;
    map["allowances"] = allowance;
    map["enterprise_id"] = enterpriseId;
    map["salary_status"] = status;
    return map;
  }
}
