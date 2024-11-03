import 'dart:convert';

import 'package:nloffice_hrm/api_services/profile_service.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';

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
    final response = await service.getDepartmentMembers(departmentID);

    if (response.statusCode == 200) {
      return List<Profiles>.from(
          json.decode(response.body).map((x) => Profiles.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> addProfile(Profiles profile) async {
    final response = await service.addNewProfile(profile);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to add profile: ${response.statusCode}');
    }
  }
  Future<bool> emailLogin(String email, String password) async {
  final response = await service.emailLogin(email, password);  
  if (response.statusCode == 200 || response.statusCode == 201) {
    return true;
  } else {
    throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
  }
}

Future<bool> phoneLogin(String phone, String password) async {
  final response = await service.phoneLogin(phone, password);
  if (response.statusCode == 200 || response.statusCode == 201) {
    return true;
  } else {
    throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
  }
}

 Future<Profiles> getProfileInfoByID(int profileID) async {
    final response = await service.getProfileInfoByID(profileID);

    if (response.statusCode == 200) {
      return Profiles.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load profile info: ${response.statusCode} - ${response.body}');
    }
  }
}
