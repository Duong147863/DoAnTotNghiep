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
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }
}
