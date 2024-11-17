import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/repository/profiles_repo.dart';

class ProfilesViewModel extends ChangeNotifier {
  final ProfilesRepository repository = ProfilesRepository();

  List<Profiles> allProfiles = [];
  List<Profiles> membersDepartment = [];
  List<Profiles> listProfilesByPosition = [];
  bool isChangingPassword = false; // Trạng thái khi đang thay đổi mật khẩu
  bool fetchingData = false;
  List<Profiles> get listProfiles => allProfiles;
  List<Profiles> get listMembersOfDepartment => membersDepartment;
  int quitCount = 0; // Số lượng nhân viên đã nghỉ việc
  int activeCount = 0; // Số lượng nhân viên đang làm việc
  int totalMembers = 0; // Biến lưu trữ tổng số nhân viên
  //
  Profiles? selectedProfile;
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
    try {
      final counts = await repository.getQuitAndActiveMembersCount();

      // Cập nhật số lượng nhân viên đã nghỉ việc và đang làm việc
      quitCount = counts['quitCount'] ?? 0;
      activeCount = counts['activeCount'] ?? 0;
      fetchingData = false;
      // Gọi notifyListeners để cập nhật UI
      notifyListeners();
    } catch (e) {
      fetchingData = false;
      throw Exception('Failed to fetch members count: $e');
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

  Future<void> addProfile(Profiles profile) async {
    try {
      await repository.addProfile(profile);
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }

  Future<void> updateProfile(Profiles profile) async {
    try {
      await repository.updateProfile(profile);
    } catch (e) {
      throw Exception('Failed to add datas: $e');
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
  ) async {
    isChangingPassword = true; // Đánh dấu bắt đầu thay đổi mật khẩu
    notifyListeners();

    try {
      bool isSuccess = await repository.changePassword(
        profileID,
        currentPassword,
        newPassword,
        confirmNewPassword,
      );
      if (isSuccess) {
        // Cập nhật lại trạng thái sau khi thay đổi mật khẩu thành công
        isChangingPassword = false;
        notifyListeners();
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      isChangingPassword = false;
      notifyListeners();
      throw Exception('Failed to change password: $e');
    }
  }
}
