import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/labor_contracts_model.dart';
import 'package:nloffice_hrm/repository/labor_contact_repo.dart';

class LaborContactsViewModel extends ChangeNotifier {
  final LaborContactRepository repository = LaborContactRepository();
  List<LaborContracts> _list = [];
  bool fetchingData = false;
  List<LaborContracts> get listLaborContact => _list;

  Future<void> addNewLaborContact(LaborContracts laborContact) async {
    try {
      await repository.addLaborContact(laborContact);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create data: $e');
    }
  }
}
