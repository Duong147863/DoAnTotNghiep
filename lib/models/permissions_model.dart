class PermissionsModel {
  PermissionsModel({
    required this.permissionID,
    required this.permissionName,
  });
  String permissionID;
  String permissionName;
  factory PermissionsModel.fromJson(Map<String, dynamic> json) {
    return PermissionsModel(
        permissionID: json["permission_id"],
        permissionName: json["permission_name"]);
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["permission_id"] = permissionID;
    map["permission_name"] = permissionName;
    return map;
  }
}
