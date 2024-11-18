class Roles 
{
  Roles({
    required this.roleID,
    required this.roleName,
  });
  int roleID;
  String roleName;
  factory Roles.fromJson(Map<String, dynamic> json) {
    return Roles(roleID: json["role_id"], roleName: json["role_name"]);
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["role_id"] = roleID;
    map["role_name"] = roleName;
    return map;
  }
}
