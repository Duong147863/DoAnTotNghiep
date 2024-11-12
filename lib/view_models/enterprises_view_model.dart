import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/enterprises_model.dart';
import 'package:nloffice_hrm/repository/enterprises_repo.dart';

class EnterprisesViewModel extends ChangeNotifier {
  final EnterprisesRepository repository = EnterprisesRepository();

  bool fetchingData = false;
  List<Enterprises> _list = [];
  List<Enterprises> get listEnterprises => _list;
   Future<void> fetchAllEnterprises() async {
    fetchingData = true;
    notifyListeners();
    try {
      _list = await repository.fetchAllEnterprises();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }
}
