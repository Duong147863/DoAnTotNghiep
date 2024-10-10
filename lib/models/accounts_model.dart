class Accounts {
  int? accountId;
  int? enterpriseId;
  int? permission; // mặc định 0 là superadmin, 1 là admin, 2 là nhân viên
  int? accountStatus;
  String? email_or_phone;
  String? password;
  Accounts(
      {this.accountId,
      this.enterpriseId,
      this.permission,
      this.accountStatus,
      this.email_or_phone,
      this.password});

  factory Accounts.fromJson(Map<String, dynamic> json) {
    return Accounts(
      accountId: json["account_id"],
      enterpriseId: json["enterprise_id"],
      permission: json["permission"],
      accountStatus: json["account_status"],
      email_or_phone: json["email_or_phone"].toString(),
      password: json["password"].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["account_id"] = accountId;
    map["enterprise_id"] = enterpriseId;
    map["permission"] = permission;
    map["account_status"] = accountStatus;
    map["email_or_phone"] = email_or_phone;
    map["password"] = password;
    return map;
  }
}

//
// ResponseLogin responseLoginFromJson(String str) =>
//     ResponseLogin.fromJson(json.decode(str));

// String responseLoginToJson(ResponseLogin data) => json.encode(data.toJson());

// class ResponseLogin {
//   ResponseLogin(
//       {this.result, this.message, this.data, this.laravelValidationError});

//   bool? result;
//   String? message;
//   Accounts? data;
//   LaravelValidationError? laravelValidationError;

//   factory ResponseLogin.fromJson(Map<String, dynamic> json) => ResponseLogin(
//       result: json["result"],
//       message: json["message"],
//       data: json["data"] != null ? Accounts.fromJson(json["data"]) : null,
//       laravelValidationError: json["error"] != null
//           ? LaravelValidationError.fromJson(json["error"])
//           : null);

//   Map<String, dynamic> toJson() => {
//         "result": result,
//         "message": message,
//         // "data": data!.toJson(),
//       };
// }

// class LaravelValidationError {
//   // kiểm tra người dùng nhập đăng nhập với API
//   final String? email_or_phone;
//   final String? password;

//   LaravelValidationError({this.email_or_phone, this.password});

//   factory LaravelValidationError.fromJson(Map<String, dynamic> json) {
//     return LaravelValidationError(
//         email_or_phone: json["email_or_phone"] != null ? json["email_or_phone"][0] : null,
//         password: json["password"] != null ? json["password"][0] : null);
//   }
// }
