import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  Future<http.Response> getProfileInfoByID(int profileID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(
      AppStrings.TOKEN,
    );
    return await http.get(
        Uri.parse('${AppStrings.baseUrlApi}profile/info/$profileID'),
        headers: {
          'Authorization': 'Bearer $token',
        });
  }

  Future<http.Response> getAllProfile() async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}profiles'), headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
    });
  }

  Future<http.Response> getAllQuitMembers() async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}profiles/quit'), headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
    });
  }

  Future<http.Response> getQuitAndActiveMembersCount() async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}profiles/count'), headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
    });
  }
   Future<http.Response> getMembersCountGenderAndMaritalStatus() async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}profiles/MembersCountGenderAndMaritalStatus'), headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
    });
  }

  Future<http.Response> getAllProfileByPosition(
      String positionID, String token) async {
    return await http.get(
        Uri.parse('${AppStrings.baseUrlApi}profiles/position/$positionID'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
        });
  }

  Future<http.Response> getDepartmentMembers(
      String departmentID) async {
    return await http.get(
        Uri.parse('${AppStrings.baseUrlApi}profiles/department/$departmentID'),
       headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
        });
  }

  Future<http.Response> addNewProfile(Profiles profile) async {
    return await http.post(
      Uri.parse('${AppStrings.baseUrlApi}profile/auth/register'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(profile.toJson()),
    );
  }

  Future<http.Response> updateProfile(Profiles profile) async {
    return await http.put(
      Uri.parse(
          '${AppStrings.baseUrlApi}profile/update'), // URL để cập nhật hồ sơ
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json
          .encode(profile.toJson()), // Chuyển đổi đối tượng Profiles thành JSON
    );
  }
Future<http.Response> deleteProfile(String profileId) async {
  return await http.put(
    Uri.parse('${AppStrings.baseUrlApi}profile/delete'),
    headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: json.encode({
      'profile_id': profileId,
    }),
  );
}


  Future<http.Response> logout(String token) async {
    return await http.post(
      Uri.parse('${AppStrings.baseUrlApi}logout'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  //Duong
  Future<http.Response> emailLogin(String email, String password) async {
    return await http.post(
      Uri.parse('${AppStrings.baseUrlApi}auth/login/email'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({"email": email, "password": password}),
    );
  }

  Future<http.Response> phoneLogin(String phone, String password) async {
    return await http.post(
      Uri.parse('${AppStrings.baseUrlApi}auth/login/phone'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode({"phone": phone, "password": password}),
    );
  }

  // Thêm phương thức đổi mật khẩu
  Future<http.Response> changePassword(
    String profileId,
    String currentPassword,
    String newPassword,
    String newPasswordConfirmation,
  ) async {
    return await http.post(
      Uri.parse('${AppStrings.baseUrlApi}profile/changePassword'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'profile_id': profileId,
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      }),
    );
  }
}
