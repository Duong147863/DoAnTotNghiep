import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';

class ProfileService {
  Future<http.Response> getProfileInfoByID(int profileID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}profile/info/$profileID'));
  }

  Future<http.Response> getAllProfile() async {
    return await http.get(Uri.parse('${AppStrings.baseUrlApi}profiles'));
  }

  Future<http.Response> getDepartmentMembers(String departmentID) async {
    return await http.get(
        Uri.parse('${AppStrings.baseUrlApi}department/members/$departmentID'));
  }

  Future<http.Response> addNewProfile(Profiles profile) async {
    final url = Uri.parse('${AppStrings.baseUrlApi}profile/auth/register');
    return await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: json.encode(profile.toJson()),
    );
  }

  Future<http.Response> emailLogin(String email, String password) async {
    return await http
        .post(Uri.parse('${AppStrings.baseUrlApi}auth/login/email'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    }, body: <String, dynamic>{
      "email": email,
      "password": password
    });
  }

  Future<http.Response> phoneLogin(String phone, String password) async {
    return await http
        .post(Uri.parse('${AppStrings.baseUrlApi}auth/login/phone'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    }, body: <String, dynamic>{
      "phone": phone,
      "password": password
    });
  }
}
