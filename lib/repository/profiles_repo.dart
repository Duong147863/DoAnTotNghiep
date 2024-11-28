import 'dart:convert';

import 'package:nloffice_hrm/api_services/profile_service.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class ProfilesRepository {
  final ProfileService service = ProfileService();
  Future<int> getAllQuitMembers() async {
    final response = await service.getAllQuitMembers();
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['totals']; // Trả về số lượng nhân viên đã nghỉ việc
    } else {
      throw Exception('Failed to load quit members count');
    }
  }

  // Hàm gọi API để lấy số lượng nhân viên đã nghỉ việc và đang làm việc
  Future<Map<String, int>> getQuitAndActiveMembersCount() async {
    final response = await service.getQuitAndActiveMembersCount();

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'quitCount': data['quitCount'],
        'activeCount': data['activeCount'],
        'officialContractsCount': data['officialContractsCount'],
        'temporaryContractsCount': data['temporaryContractsCount'],
      };
    } else {
      throw Exception('Failed to load members count');
    }
  }

  Future<Map<String, int>> getMembersCountGenderAndMaritalStatus() async {
    final response = await service.getMembersCountGenderAndMaritalStatus();

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Trả về số lượng nhân viên đã nghỉ việc và đang làm việc
      return {
        'genderMan': data['genderMan'],
        'genderWoman': data['genderWoman'],
        'married': data['married'],
        'unmarried': data['unmarried']
      };
    } else {
      throw Exception('Failed to load members count');
    }
  }

  Future<List<Profiles>> fetchAllProfiles() async {
    final response = await service.getAllProfile();
    if (response.statusCode == 200) {
      return List<Profiles>.from(
          json.decode(response.body).map((x) => Profiles.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> fetchMembersOfDepartment(
      String departmentID) async {
    final response = await service.getDepartmentMembers(departmentID);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Profiles> profiles = List<Profiles>.from(
        data['profiles'].map((x) => Profiles.fromJson(x)),
      );
      int totalMembers = data['totals'];

      return {
        'profiles': profiles,
        'totals': totalMembers,
      };
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addProfile(Profiles profile, Function(String) callback) async {
    try {
      final response = await service.addNewProfile(profile);

      if (response.statusCode == 200 || response.statusCode == 201) {
        callback('Nhân viên đã được thêm thành công.'); // Success message
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['message'] != null) {
          callback(responseData['message']); // Pass the message to the callback
        } else {
          callback('Đã xảy ra lỗi không xác định');
        }
      }
    } catch (e) {
      callback('Lỗi: $e'); // Pass error message to callback
    }
  }

  Future<void> updateProfile(
      Profiles profile, Function(String) callback) async {
    try {
      // Gửi yêu cầu cập nhật thân nhân
      final response = await service.updateProfile(profile);

      if (response.statusCode == 200) {
        callback(
            'Nhân viên đã được cập nhật thành công.'); // Thông báo thành công
      } else {
        // Giải mã nội dung phản hồi
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['message'] != null) {
          callback(responseData['message']); // Hiển thị thông báo lỗi từ API
        } else {
          callback('Đã xảy ra lỗi không xác định'); // Thông báo lỗi chung chung
        }
      }
    } catch (e) {
      callback('Lỗi: $e'); // Thông báo lỗi ngoại lệ
    }
  }

  Future<bool> deleteProfile(String profileId) async {
    final response = await service.deleteProfile(profileId);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to deactivate profile: ${response.statusCode}');
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
        throw Exception('Failed to change password: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to change password');
    }
  }
}
