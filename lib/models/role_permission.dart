class RolePermission {
  RolePermission({
    required this.roleID,
    required this.permissionID,
  });
  String roleID;
  String permissionID;
  factory RolePermission.fromJson(Map<String, dynamic> json) {
    return RolePermission(
        roleID: json["role_id"], permissionID: json["permission_id"]);
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["role_id"] = roleID;
    map["permission_id"] = permissionID;
    return map;
  }
}
