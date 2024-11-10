class Enterprises // Doanh nghiệp
{
  Enterprises({
    this.enterpriseId = 0,
    required this.name,
    required this.licenseNum,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
    required this.assignDate,
  });
  int enterpriseId;
  String name;
  String licenseNum;
  String email;
  String phone;
  String website;
  String address;
  DateTime assignDate;
  factory Enterprises.fromJson(Map<String, dynamic> json) {
    return Enterprises(
        enterpriseId: json["enterprise_id"],
        name: json["name"],
        licenseNum: json["license_num"],
        email: json["email"],
        phone: json["phone"],
        website: json["website"],
        address: json["address"],
        //   assignDate: json["assign_date"]!= null
        //       ? DateTime.parse(json["assign_date"])
        //       : null,
        assignDate: json["assign_date"]);
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["enterprise_id"] = enterpriseId;
    map["name"] = name;
    map["license_num"] = licenseNum;
    map["email"] = email;
    map["phone"] = phone;
    map["website"] = website;
    map["address"] = address;
    map["assign_date"] = assignDate;
    return map;
  }
}
