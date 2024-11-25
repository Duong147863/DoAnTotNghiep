import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';
import 'package:nloffice_hrm/repository/relatives_repo.dart';

class RelativesViewModel extends ChangeNotifier {
  final RelativesRepository repository = RelativesRepository();

  List<Relatives> _list = [];
  bool fetchingData = false;
  List<Relatives> get listRelatives => _list;
  String? errorMessage;
  Future<void> fetchAllRelatives(String profileId) async {
    fetchingData = true;
    notifyListeners();
    try {
      _list = await repository.fetchAllRelatives(profileId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }

    // Modify addRelative method to accept a callback for success messages
  Future<void> addRelative(Relatives relatives, Function(String) callback) async {
    try {
      await repository.addRelative(relatives,callback); // Call the repository method
    } catch (e) {
      callback('Failed to add relative: $e');  // Call the callback with error message
    }
  }

  Future<void> updateRelatives(Relatives relatives, Function(String) callback) async {
    try {
      await repository.updateRelative(relatives,callback);
      int index =
          _list.indexWhere((relav) => relav.relativeId == relatives.relativeId);
      if (index != -1) {
        _list[index] = relatives;
        notifyListeners();
      }
    } catch (e) {
      callback('Failed to add relative: $e');  // Call the callback with error message
    }
  }
    Future<void> deleteRelative(int relativesId) async {
    try {
      bool success = await repository.deleteRelative(relativesId);
      if (success) {
        _list.removeWhere((rela) => rela.relativeId == relativesId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete relatives');
      }
    } catch (e) {
      throw Exception('Failed to delete relatives: $e');
    }
  }
}
