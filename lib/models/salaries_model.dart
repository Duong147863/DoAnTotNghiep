class Salaries {
  Salaries(
      {required this.salaryId,
      required this.salaryCoeffcient,
      this.allowances,
      this.bonus,
      this.minus,
      required this.peronalTax,
      required this.advanceMoney});
  String salaryId;
  double salaryCoeffcient;
  double? allowances;
  double? bonus;
  double? minus;
  double peronalTax;
  double advanceMoney;
  factory Salaries.fromJson(Map<String, dynamic> json) {
    return Salaries(
      salaryId: json["salary_id"],
      salaryCoeffcient: (json["salary_coefficient"] is int)
          ? (json["salary_coefficient"] as int).toDouble()
          : json["salary_coefficient"],
      allowances: (json["allowances"] is int)
          ? (json["allowances"] as int).toDouble()
          : json["allowances"],
      bonus: (json["bonus"] is int)
          ? (json["bonus"] as int).toDouble()
          : json["bonus"],
      minus: (json["minus"] is int)
          ? (json["minus"] as int).toDouble()
          : json["minus"],
      peronalTax: (json["personal_tax"] is int)
          ? (json["personal_tax"] as int).toDouble()
          : json["personal_tax"],
      advanceMoney: (json["advance_money"] is int)
          ? (json["advance_money"] as int).toDouble()
          : json["advance_money"],
    );

  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["salary_id"] = salaryId;
    map["salary_coefficient"] = salaryCoeffcient;
    map["allowances"] = allowances;
    map["bonus"] = bonus;
    map["minus"] = minus;
    map["personal_tax"] = peronalTax;
    map["advance_money"] = advanceMoney;
    return map;
  }
}
