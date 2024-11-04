class RolesModel 
{
  RolesModel({
    required this.roleID,
    required this.roleName,
  });
  String roleID;
  String roleName;
  factory RolesModel.fromJson(Map<String, dynamic> json) {
    return RolesModel(roleID: json["role_id"], roleName: json["role_name"]);
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["role_id"] = roleID;
    map["role_name"] = roleName;
    return map;
  }
}
