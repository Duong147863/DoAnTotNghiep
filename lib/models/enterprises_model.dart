class Enterprises // Doanh nghiệp
{
  Enterprises(
      {this.enterpriseId=0,
      required this.name,
      required this.licenseNum,
      this.email,
      this.phone,
      required this.assignDate,
      });
  int enterpriseId;
  String name;
  String licenseNum; 
  String? email;
  String? phone;
  DateTime assignDate;
  factory Enterprises.fromJson(Map<String,dynamic>json){
    return Enterprises(
      enterpriseId: json["enterprise_id"],
      name: json["name"],
      licenseNum: json["license_num"],
      email: json["email"],
      phone: json["phone"],
    //   assignDate: json["assign_date"]!= null 
    //       ? DateTime.parse(json["assign_date"]) 
    //       : null,
      assignDate: json["assign_date"]
    );
  }
  Map<String,dynamic> toJson(){
    final map=<String,dynamic>{};
    map["enterprise_id"]=enterpriseId;
    map["name"]=name;
    map["license_num"]=licenseNum;
    map["email"]=email;
    map["phone"]=phone;
    map["assign_date"]=assignDate;
    return map;
  }
}
