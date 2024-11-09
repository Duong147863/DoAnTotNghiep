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

  Future<http.Response> getAllProfile(String token) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}profiles'), headers: {
      'Authorization': 'Bearer $token',
    });
  }

  Future<http.Response> getDepartmentMembers(
      String departmentID, String token) async {
    return await http.get(
        Uri.parse('${AppStrings.baseUrlApi}department/members/$departmentID'),
        headers: {
          'Authorization': 'Bearer $token',
        });
  }

  Future<http.Response> addNewProfile(Profiles profile) async {
    return await http.post(
      Uri.parse('${AppStrings.baseUrlApi}profile/auth/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(profile.toJson()),
    );
  }

  Future<http.Response> updateProfile(Profiles profile, String token) async {
    return await http.put(
      Uri.parse(
          '${AppStrings.baseUrlApi}profile/info/update'), // URL để cập nhật hồ sơ
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json
          .encode(profile.toJson()), // Chuyển đổi đối tượng Profiles thành JSON
    );
  }

  Future<http.Response> logout(String token) async {
    return await http.post(
      Uri.parse('${AppStrings.baseUrlApi}logout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  //Duong
  Future<http.Response> emailLogin(String email, String password) async {
    return await http.post(
      Uri.parse('${AppStrings.baseUrlApi}auth/login/email'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
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
}
