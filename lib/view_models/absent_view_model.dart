import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/absents_model.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/repository/absent_repo.dart';

class AbsentsViewModel extends ChangeNotifier {
  final AbsentsRepository repository = AbsentsRepository();

  bool fetchingData = false;
  List<Absents> _list = [];
  List<Absents> get listAbsents => _list;
  List<Profiles> _listpro = [];
  List<Profiles> get listProfile => _listpro;
  // Future<void> addNewAbsent(Absents absents) async {
  //   try {
  //     await repository.addNewAbsent(absents);
  //     notifyListeners();
  //   } catch (e) {
  //     throw Exception('Failed to add absent: $e');
  //   }
  // }
  
  Future<void> addNewAbsent(
      Absents absents, Function(String) callback) async {
    try {
      await repository.addNewAbsent(
          absents, callback); // Call the repository method
    } catch (e) {
      callback(
          'Failed to add relative: $e'); // Call the callback with error message
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
  Future<void> getAllAbsentsbyRole(String profileId) async {
    fetchingData = true;
    try {
      _list = await repository.getAllAbsentsbyRole(profileId);
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
    Future<void> updateAbents(Absents asbents) async {
    try {
      await repository.updateAbents(asbents);

      int index =
          _list.indexWhere((abs) => abs.ID == asbents.ID);
      if (index != -1) {
        _list[index] = asbents;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update relatives: $e');
    }
  }
  Future<void> deleteAbents(int ID) async {
    try {
      bool success = await repository.deleteAbents(ID);
      if (success) {
        _list.removeWhere((abs) => abs.ID == ID);
        notifyListeners();
      } else {
        throw Exception('Failed to delete relatives');
      }
    } catch (e) {
      throw Exception('Failed to delete relatives: $e');
    }
  }
}
