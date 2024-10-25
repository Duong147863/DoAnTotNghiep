import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/repository/profiles_repo.dart';

class ProfilesViewModel extends ChangeNotifier {
  final ProfilesRepository repository = ProfilesRepository();

  List<Profiles> _list = [];
  bool fetchingData = false;
  bool addingProfile = false;
  List<Profiles> get listProfiles => _list;

  Future<void> fetchAllProfiles() async {
    fetchingData = true;
    try {
      _list = await repository.fetchAllProfiles();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load datas: $e');
    }
    fetchingData = false;
  }
   Future<void> addProfile(Profiles profile) async {
    addingProfile = true;
    notifyListeners();
    try {
      final success = await repository.addProfile(profile);
      if (success) {
        _list.add(profile); // Optional: refresh the list from server instead
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to add profile: $e');
    }
    addingProfile = false;
  }
}
