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
       salaryId: json["salary_id"] as String,
      // Kiểm tra xem giá trị có phải là kiểu int hay double và chuyển đổi tương ứng
      salaryCoefficient: (json["salary_coefficient"] is int)
          ? (json["salary_coefficient"] as int).toDouble()
          : json["salary_coefficient"] as double,
      allowances: json["allowances"] != null
          ? (json["allowances"] is int
              ? (json["allowances"] as int).toDouble()
              : json["allowances"] as double)
          : null,
      personalTax: (json["personal_tax"] is int)
          ? (json["personal_tax"] as int).toDouble()
          : json["personal_tax"] as double,
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
