class PermissionsModel {
  PermissionsModel({
    this.permissionID,
    required this.permissionName,
  });
  int? permissionID;
  String permissionName;
  factory PermissionsModel.fromJson(Map<String, dynamic> json) {
    return PermissionsModel(permissionName: json["permission_name"]);
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["permission_id"] = permissionID;
    map["permission_name"] = permissionName;
    return map;
  }
}
