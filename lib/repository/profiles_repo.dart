import 'dart:convert';

import 'package:nloffice_hrm/api_services/profile_service.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class ProfilesRepository {
  final ProfileService service = ProfileService();

  Future<List<Profiles>> fetchAllProfiles() async {
    final response = await service.getAllProfile();
    if (response.statusCode == 200) {
      return List<Profiles>.from(
          json.decode(response.body).map((x) => Profiles.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Profiles>> fetchMembersOfDepartment(String departmentID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppStrings.TOKEN);
    final response = await service.getDepartmentMembers(departmentID, token!);
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      return List<Profiles>.from(json
          .decode(response.body)['profiles']
          .map((x) => Profiles.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> addProfile(Profiles profile) async {
    final response = await service.addNewProfile(profile); //
    if (response.statusCode == 200) {
      print("add successful. Response body: ${response.body}");
      return true;
    } else {
      print("Response body: ${response.body}");
      throw Exception('Failed to add profile: ${response.statusCode}');
    }
  }

  Future<bool> updateProfile(Profiles profile) async {
    try {
      final response = await service
          .updateProfile(profile); // Gọi phương thức từ ProfileService
      if (response.statusCode == 200) {
        return true; // Cập nhật thành công
      } else {
        print("Response body: ${response.body}");
        throw Exception('Failed to update profile');
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to update profile');
    }
  }

  Future<Profiles> emailLogin(String email, String password) async {
    final response = await service.emailLogin(email, password);
    if (response.statusCode == 200 || response.statusCode == 201) {
      //save on the shared preferences that the user is logged in
      AppStrings.TOKEN = json.decode(response.body)['token']; // CHUỖI TOKEN
      print(AppStrings.TOKEN);
      AppStrings.ROLE_PERMISSIONS = List<String>.from(json
          .decode(response.body)['role_permissions']
          .map((e) => e['permission_name'] as String));
      print(AppStrings.ROLE_PERMISSIONS); // DANH SÁCH CÁC QUYỀN HẠN CHỨC NĂNG
      return Profiles.fromJson(json.decode(response.body)['user']);
    } else {
      throw Exception(
          'Failed to login: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Profiles> phoneLogin(String phone, String password) async {
    final response = await service.phoneLogin(phone, password);
    if (response.statusCode == 200 || response.statusCode == 201) {
      AppStrings.TOKEN = json.decode(response.body)['token']; // CHUỖI TOKEN
      AppStrings.ROLE_PERMISSIONS = List<String>.from(json
          .decode(response.body)['role_permissions']
          .map((e) => e['permission_name'] as String));
      print(AppStrings.ROLE_PERMISSIONS); // DANH SÁCH CÁC QUYỀN HẠN CHỨC NĂNG
      print(AppStrings.TOKEN);
      return Profiles.fromJson(json.decode(response.body)['user']);
    } else {
      throw Exception(
          'Failed to login: ${response.statusCode} - ${response.body}');
    }
  }

  Future<bool> logOut() async {
    final response = await service.logout(AppStrings.TOKEN);
    if (response.statusCode == 200 || response.statusCode == 201) {
      AppStrings.ROLE_PERMISSIONS = [];
      AppStrings.TOKEN = "";
      return true;
    } else {
      throw Exception('Failed to logout: ${response.statusCode}');
    }
  }

  Future<Profiles> getProfileInfoByID(int profileID) async {
    final response = await service.getProfileInfoByID(profileID);
    if (response.statusCode == 200) {
      return Profiles.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to load profile info: ${response.statusCode} - ${response.body}');
    }
  }

  Future<bool> changePassword(String profileID, String currentPassword,
      String newPassword, String confirmNewPassword) async {
    try {
      final response = await service.changePassword(
          profileID, currentPassword, newPassword, confirmNewPassword);
      if (response.statusCode == 200) {
        print("Password change successful");
        print("Update successful. Response body: ${response.body}");
        return true;
      } else {
        print("Failed to change password: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to change password: ${response.statusCode}');
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to change password');
    }
  }
}
