import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/repository/profiles_repo.dart';

class ProfilesViewModel extends ChangeNotifier {
  final ProfilesRepository repository = ProfilesRepository();

  List<Profiles> allProfiles = [];
  List<Profiles> listmembersOfDepartment = [];

  bool fetchingData = false;
  List<Profiles> get listProfiles => allProfiles;
  List<Profiles> get listMembersOfDepartment => listmembersOfDepartment;
  //
  Profiles? selectedProfile;
  Future<void> fetchAllProfiles() async {
    fetchingData = true;
    try {
      allProfiles = await repository.fetchAllProfiles();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load datas: $e');
    }
    fetchingData = false;
  }

  Future<void> membersOfDepartment(String departmentID) async {
    try {
      listmembersOfDepartment =
          await repository.fetchMembersOfDepartment(departmentID);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load datas: $e');
    }
  }

  Future<void> addProfile(Profiles profile) async {
    try {
      await repository.addProfile(profile);
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }

  Future<void> loginEmail(String email, String password) async {
    try {
      await repository.emailLogin(email, password);
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> loginPhone(String phone, String password) async {
    try {
      await repository.phoneLogin(phone, password);
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
}
