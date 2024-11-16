import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/absents_model.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/repository/absent_repo.dart';

class AbsentsViewModel extends ChangeNotifier {
  final AbsentsRepository repository = AbsentsRepository();

  bool fetchingData = false;
  List<Absents> _list = [];
  List<Absents> get listAbsents => _list;
  Future<void> addNewAbsent(Absents absents) async {
    try {
      await repository.addNewAbsent(absents);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add absent: $e');
    }
  }

  Future<void> fetchAllAbsents() async {
    fetchingData = true;
    try {
      _list = await repository.fetchAllAbsents();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }

  // Fetch absents based on the profileId
  Future<void> getPersonalAbsents(String profileId) async {
    fetchingData = true;
    try {
      List<Absents> allAbsents = await repository.getPersonalAbsents(profileId);
      // Filter absents by matching profileID
      _list =
          allAbsents.where((absent) => absent.profileID == profileId).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }
}
