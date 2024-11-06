class Salaries {
  Salaries({
    required this.salaryId,
    required this.salaryCoefficient,
    this.allowances,
    required this.personalTax,
  });

  String salaryId;
  double salaryCoefficient;
  double? allowances;
  double personalTax;

  factory Salaries.fromJson(Map<String, dynamic> json) {
    return Salaries(
      salaryId: json["salary_id"],
      salaryCoefficient:double.parse(json["salary_coefficient"]),
      allowances:double.parse(json["allowances"]),
      personalTax: double.parse(json["personal_tax"])
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["salary_id"] = salaryId;
    map["salary_coefficient"] = salaryCoefficient;
    map["allowances"] = allowances;
    map["personal_tax"] = personalTax;
    return map;
  }
}
