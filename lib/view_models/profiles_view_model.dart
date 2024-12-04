import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/provinces.dart';
import 'package:nloffice_hrm/repository/profiles_repo.dart';

class ProfilesViewModel extends ChangeNotifier {
  final ProfilesRepository repository = ProfilesRepository();

  List<Profiles> allProfiles = [];
  List<Profiles> _list = [];
  List<Profiles> get listProfile => _list;
  List<Profiles> membersDepartment = [];
  List<Profiles> listProfilesByPosition = [];
  bool isChangingPassword = false; // Trạng thái khi đang thay đổi mật khẩu
  bool fetchingData = false;
  bool fetchingEmployeeStats =
      false; // Trạng thái cho widget _buildEmployeeStats
  bool fetchingGenderStats =
      false; // Trạng thái cho widget _buildGetMembersCountGenderAndMaritalStatus
  List<Profiles> get listProfiles => allProfiles;
  List<Profiles> get listMembersOfDepartment => membersDepartment;
  int quitCount = 0; // Số lượng nhân viên đã nghỉ việc
  int activeCount = 0; // Số lượng nhân viên đang làm việc
  int totalMembers = 0; // Biến lưu trữ tổng số nhân viên
  int genderMan = 0;
  int genderWoman = 0;
  int officialContractsCount = 0;
  int temporaryContractsCount = 0;
  int probationaryEmployeeCount = 0;
  int married = 0;
  int unmarried = 0;
  //
  Profiles? selectedProfile;
  // Api lấy Map
  List<String> provinces = []; // Added for province data
  List<String> get listProvinces => provinces;

  Future<List<Province>> fetchProvinces() async {
  final String response = await rootBundle.loadString('assets/json/list_provinces_arr.json');
  final List<dynamic> data = json.decode(response);

  return data.map((json) => Province.fromJson(json)).toList();
}
  Future<void> fetchAllProfiles() async {
    fetchingData = true;
    try {
      // Lấy toàn bộ danh sách nhân viên
      allProfiles = await repository.fetchAllProfiles();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load profiles: $e');
    }
    fetchingData = false;
  }

  //////
  Future<void> fetchQuitMembersCount() async {
    try {
      quitCount = await repository
          .getAllQuitMembers(); // Lấy số lượng nhân viên đã nghỉ việc
      notifyListeners(); // Cập nhật lại UI
    } catch (e) {
      throw Exception('Failed to load quit members count: $e');
    }
    fetchingData = false;
  }

  ///////
  Future<void> fetchQuitAndActiveMembersCount() async {
    fetchingEmployeeStats = true;
    notifyListeners();
    try {
      final counts = await repository.getQuitAndActiveMembersCount();

      quitCount = counts['quitCount'] ?? 0;
      activeCount = counts['activeCount'] ?? 0;
      probationaryEmployeeCount=counts['probationaryEmployee'] ?? 0;
      officialContractsCount=counts['officialContractsCount'] ?? 0;
      temporaryContractsCount=counts['temporaryContractsCount'] ?? 0;
    } catch (e) {
      throw Exception('Failed to fetch members count: $e');
    } finally {
      fetchingEmployeeStats = false;
      notifyListeners();
    }
  }

  Future<void> getMembersCountGenderAndMaritalStatus() async {
    fetchingGenderStats = true;
    notifyListeners();
    try {
      final counts = await repository.getMembersCountGenderAndMaritalStatus();
      genderMan = counts['genderMan']??0;
      genderWoman = counts['genderWoman']??0;
      married = counts['married']??0;
      unmarried = counts['unmarried']??0;
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to fetch members count: $e');
    } finally {
      fetchingGenderStats = false;
      notifyListeners();
    }
  }

  Future<void> membersOfDepartment(String departmentID) async {
    fetchingData = true;
    notifyListeners();
    try {
      var result = await repository.fetchMembersOfDepartment(departmentID);
      membersDepartment = result['profiles'];
      totalMembers = result['totals'];
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
    notifyListeners();
  }

   Future<void> addProfile(Profiles profile, Function(String) callback) async {
    try {
      await repository.addProfile(profile,callback); // Call the repository method
      await membersOfDepartment(profile.profileId);
      await getMembersCountGenderAndMaritalStatus();
      // await fetchQuitAndActiveMembersCount();
      notifyListeners();
    } catch (e) {
      callback('Failed to add relative: $e');  // Call the callback with error message
    }
  }
  // Future<void> updateProfile(Profiles profile, Function(String) callback) async {
  //   try {
  //     await repository.updateProfile(profile,callback);
  //     await membersOfDepartment(profile.profileId);
  //     await getMembersCountGenderAndMaritalStatus();
  //   } catch (e) {
  //     callback('Failed to add relative: $e');  // Call the callback with error message
  //   }
  // }
     Future<void> updateProfile(Profiles profile, Function(String) callback) async {
    try {
      await repository.updateProfile(profile,callback);
      await membersOfDepartment(profile.profileId);
      await getMembersCountGenderAndMaritalStatus();
      int index =
          _list.indexWhere((pro) => pro.profileId == profile.profileId);
      if (index != -1) {
        _list[index] = profile;
        notifyListeners();
      }
    } catch (e) {
      callback('Failed to add relative: $e');  // Call the callback with error message
    }
  }
  Future<void> deleteProfile(String profileID) async {
  try {
   
    await repository.deleteProfile(profileID);
    await membersOfDepartment(profileID);
    // await fetchQuitAndActiveMembersCount();
    // await fetchAllProfiles();
    notifyListeners();
  } catch (e) {
    throw Exception('Failed to deactivate profile: $e');
  }
}

  Future<void> logOut() async {
    try {
      await repository.logOut();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  Future<Profiles> loginEmail(String email, String password) async {
    try {
      return await repository.emailLogin(email, password);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<Profiles> loginPhone(String phone, String password) async {
    try {
      return await repository.phoneLogin(phone, password);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> getProfileInfoByID(int profileID) async {
    try {
      selectedProfile = await repository.getProfileInfoByID(profileID);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load profile info: $e');
    }
  }
  Future<void> changePassword(
  String profileID,
  String currentPassword,
  String newPassword,
  String confirmNewPassword,
  Function(String) callback,
) async {
  try {
    isChangingPassword = true;
    notifyListeners(); // Thông báo trạng thái thay đổi

    bool isSuccess = await repository.changePassword(
      profileID,
      currentPassword,
      newPassword,
      confirmNewPassword,
      callback,
    );

    if (isSuccess) {
      isChangingPassword = false;
      notifyListeners(); // Thông báo hoàn tất
    }
  } catch (e) {
    isChangingPassword = false;
    callback('Lỗi khi đổi mật khẩu: $e'); // Thông báo lỗi
  }
}
 Future<void> getPassword(
  String profileID,
  String newPassword,
  String confirmNewPassword,
  Function(String) callback,
) async {
  try {
    isChangingPassword = true;
    notifyListeners(); // Thông báo trạng thái thay đổi

    bool isSuccess = await repository.getPassword(
      profileID,
      newPassword,
      confirmNewPassword,
      callback,
    );

    if (isSuccess) {
      isChangingPassword = false;
      notifyListeners(); // Thông báo hoàn tất
    }
  } catch (e) {
    isChangingPassword = false;
    callback('Lỗi khi đổi mật khẩu: $e'); // Thông báo lỗi
  }
}
}
