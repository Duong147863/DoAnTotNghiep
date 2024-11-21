import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/labor_contracts_model.dart';
import 'package:nloffice_hrm/repository/labor_contact_repo.dart';
import 'package:nloffice_hrm/view_models/profiles_view_model.dart';

class LaborContactsViewModel extends ChangeNotifier {
  final LaborContactRepository repository = LaborContactRepository();
  final ProfilesViewModel profilesViewModel= ProfilesViewModel();
  List<LaborContracts> _list = [];
  bool fetchingData = false;
  List<LaborContracts> get listLaborContact => _list;

  Future<void> addNewLaborContact(LaborContracts laborContact) async {
    try {
      await repository.addLaborContact(laborContact);
      // await getLaborContactOf(laborContact.laborContractId);
      await profilesViewModel.fetchQuitAndActiveMembersCount();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create data: $e');
    }
  }

  Future<void> getLaborContactOf(String laborContactId) async {
    try {
      List<LaborContracts> laborContactList =
          await repository.getLaborContactOf(laborContactId);
      _list = laborContactList
          .where((lab) => lab.laborContractId == laborContactId)
          .toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load LaborContracts: $e');
    }
  }
   Future<void> updateLaborContact(LaborContracts laborContact) async {
    try {
      await repository.updateLaborContact(laborContact);
      int index =
          _list.indexWhere((lab) => lab.laborContractId == laborContact.laborContractId);
      if (index != -1) {
        _list[index] = laborContact;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update Training Processes: $e');
    }
  }

  Future<void> deleteLaborContact(String laborContractId) async {
    try {
      bool success = await repository.deleteLaborContact(laborContractId);
      if (success) {
        _list.removeWhere((lab) => lab.laborContractId == laborContractId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete Trainingprocesses');
      }
    } catch (e) {
      throw Exception('Failed to delete Trainingprocesses: $e');
    }
  }
}
