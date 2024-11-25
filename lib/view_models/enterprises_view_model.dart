import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/enterprises_model.dart';
import 'package:nloffice_hrm/repository/enterprises_repo.dart';

class EnterprisesViewModel extends ChangeNotifier {
  final EnterprisesRepository repository = EnterprisesRepository();

  Enterprises? enterprises;
  bool fetchingData = false;

  Future<void> fetchAllEnterprises() async {
    fetchingData = true;
    try {
      enterprises = await repository.fetchAllEnterprises();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }
}
