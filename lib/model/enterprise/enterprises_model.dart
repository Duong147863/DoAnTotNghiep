class Enterprises // Doanh nghiệp
{
  Enterprises(
      {this.enterpriseId,
      this.name,
      this.licenseNum,
      this.email,
      this.phone,
      this.assignDate,
      this.enterpriseStatus});
  int? enterpriseId;
  String? name;
  String? licenseNum; // số giấy phép
  String? email;
  String? phone;
  DateTime? assignDate;
  int? enterpriseStatus;
  factory Enterprises.fromJson(Map<String,dynamic>json){
    return Enterprises(
      enterpriseId: json["enterprise_id"],
      name: json["name"],
      licenseNum: json["license_num"],
      email: json["email"],
      phone: json["phone"],
      assignDate: json["assign_date"]!= null 
          ? DateTime.parse(json["assign_date"]) 
          : null,
      enterpriseStatus: json["enterprise_status"],
    );
  }
  Map<String,dynamic> toJson(){
    final map=<String,dynamic>{};
    map["enterprise_id"]=enterpriseId;
    map["name"]=name;
    map["license_num"]=licenseNum;
    map["email"]=email;
    map["phone"]=phone;
    map["assign_date"]=assignDate?.toIso8601String();
    map["enterprise_status"]=enterpriseStatus;
    return map;
  }
}
