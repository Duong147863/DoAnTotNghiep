import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/diplomas_model.dart';
import 'package:nloffice_hrm/repository/diplomas_repo.dart';

class DiplomasViewModel extends ChangeNotifier {
  final DiplomasRepository repository = DiplomasRepository();

  List<Diplomas> _list = [];
  bool fetchingData = false;
  List<Diplomas> get listDiplomas => _list;

  Future<void> fetchAllDiplomasByEnterpriseID(int enterpriseID) async {
    fetchingData = true;
    try {
      _list = await repository.fetchAllDiplomasOfEnterprises(enterpriseID);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load datas: $e');
    }
    fetchingData = false;
  }
  Future<void> AddDiploma(Diplomas diploma) async {
    try {
      await repository.AddDiplomas(diploma);
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }
}
