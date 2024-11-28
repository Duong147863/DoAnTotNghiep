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

  // Future<void> addNewLaborContact(LaborContracts laborContact) async {
  //   try {
  //     await repository.addLaborContact(laborContact);
  //     // await getLaborContactOf(laborContact.laborContractId);
  //     await profilesViewModel.fetchQuitAndActiveMembersCount();
  //     notifyListeners();
  //   } catch (e) {
  //     throw Exception('Failed to create data: $e');
  //   }
  // }
      // Modify addRelative method to accept a callback for success messages
  Future<void> addNewLaborContact(LaborContracts laborContact, Function(String) callback) async {
    try {
      await repository.addLaborContact(laborContact,callback); // Call the repository method
    } catch (e) {
      callback('Failed to add relative: $e');  // Call the callback with error message
    }
  }
    Future<void> getLaborContactOf(String profileId) async {
    fetchingData = true;
    notifyListeners();
    try {
      _list = await repository.getLaborContactOf(profileId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }
  Future<void> updateLaborContact(LaborContracts laborContact, Function(String) callback) async {
    try {
      await repository.updateLaborContact(laborContact,callback);
      int index =
          _list.indexWhere((lab) => lab.laborContractId == laborContact.laborContractId);
      if (index != -1) {
        _list[index] = laborContact;
        notifyListeners();
      }
    } catch (e) {
      callback('Failed to add relative: $e');  // Call the callback with error message
    }
  }
}
