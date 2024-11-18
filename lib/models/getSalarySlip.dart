class Getsalaryslip {
  Getsalaryslip(
      {required this.salaryId,
      required this.salaryCoefficient,
      this.allowances,
      required this.personalTax,
      required this.profileName,
      required this.positionName,
        this.isExpanded=false,});

  String salaryId;
  double salaryCoefficient;
  double? allowances;
  double personalTax;
  String profileName;
  String positionName;
    bool isExpanded;
  factory Getsalaryslip.fromJson(Map<String, dynamic> json) {
    return Getsalaryslip(
      salaryId: json["salary_id"] as String,
      profileName: json["profile_name"],
      positionName: json["position_name"],
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
}
