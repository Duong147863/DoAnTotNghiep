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
      List<Diplomas> diplomasList =
          await repository.getDiplomasOf(profileID);
      _list = diplomasList
          .where((dip) => dip.profileId == profileID)
          .toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load working processes: $e');
    }
  }
  Future<void> AddDiploma(Diplomas diploma) async {
    try {
      await repository.AddDiplomas(diploma);
        notifyListeners();
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }
  Future<void> updateDiplomas(Diplomas diploma) async {
    try {
      await repository.updateDiplomas(diploma);
      int index =
          _list.indexWhere((dip) => dip.diplomaId == diploma.diplomaId);
      if (index != -1) {
        _list[index] = diploma;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update Training Processes: $e');
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
