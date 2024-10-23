import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/repository/profiles_repo.dart';

class ProfilesViewModel extends ChangeNotifier {
  final ProfilesRepository repository = ProfilesRepository();

  List<Profiles> _list = [];
  bool fetchingData = false;
  List<Profiles> get listProfiles => _list;

  Future<void> fetchAllProfiles() async {
    fetchingData = true;
    try {
      
    } catch (e) {
      throw Exception('Failed to load datas: $e');
    }
    fetchingData = false;
  }
}
