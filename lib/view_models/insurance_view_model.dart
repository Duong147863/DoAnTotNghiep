import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/insurance_model.dart';
import 'package:nloffice_hrm/repository/insurance_repo.dart';
class InsuranceViewModel extends ChangeNotifier {
  List<Insurance> _list = [];
  bool fetchingData = false;
  List<Insurance> get listInsurance => _list;
  final InsuranceRepository repository = InsuranceRepository();

  Future<void> getInsurancesOf(String profileID) async {
    try {
      List<Insurance> insuranceList =
          await repository.getInsurancesOf(profileID);
      _list = insuranceList
          .where((ins) => ins.profileId == profileID)
          .toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load working processes: $e');
    }
  }
  Future<void> createNewInsurances(Insurance insurance) async {
    try {
      await repository.createNewInsurances(insurance);
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }
  Future<void> updateInsurances(Insurance insurance) async {
    try {
      await repository.updateInsurances(insurance);
      int index =
          _list.indexWhere((ins) => ins.insuranceId == insurance.insuranceId);
      if (index != -1) {
        _list[index] = insurance;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update Training Processes: $e');
    }
  }

  Future<void> deleteInsurances(String insurancesId) async {
    try {
      bool success = await repository.deleteInsurances(insurancesId);
      if (success) {
        _list.removeWhere((ins) => ins.insuranceId == insurancesId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete Trainingprocesses');
      }
    } catch (e) {
      throw Exception('Failed to delete Trainingprocesses: $e');
    }
  }
}
