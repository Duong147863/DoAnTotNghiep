import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/diplomas_model.dart';
import 'package:nloffice_hrm/repository/diplomas_repo.dart';

class DiplomasViewModel extends ChangeNotifier {
  final DiplomasRepository repository = DiplomasRepository();

  List<Diplomas> _list = [];
  bool fetchingData = false;
  List<Diplomas> get listDiplomas => _list;

  Future<void> getDiplomasOf(String profileID) async {
    try {
      List<Diplomas> diplomasList = await repository.getDiplomasOf(profileID);
      _list = diplomasList.where((dip) => dip.profileId == profileID).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load working processes: $e');
    }
  }

  Future<void> AddDiploma(Diplomas diploma, Function(String) callback) async {
    try {
      await repository.AddDiplomas(
          diploma, callback); // Call the repository method
    } catch (e) {
      callback(
          'Failed to add relative: $e'); // Call the callback with error message
    }
  }

  Future<void> updateDiplomas(
      Diplomas diploma, Function(String) callback) async {
    try {
      await repository.updateDiplomas(diploma, callback);
      int index = _list.indexWhere((dip) => dip.diplomaId == diploma.diplomaId);
      if (index != -1) {
        _list[index] = diploma;
        notifyListeners();
      }
    } catch (e) {
      callback(
          'Failed to add relative: $e'); // Call the callback with error message
    }
  }

  Future<void> deleteDiplomas(String diplomaId) async {
    try {
      bool success = await repository.deleteDiplomas(diplomaId);
      if (success) {
        _list.removeWhere((dip) => dip.diplomaId == diplomaId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete Trainingprocesses');
      }
    } catch (e) {
      throw Exception('Failed to delete Trainingprocesses: $e');
    }
  }
}
