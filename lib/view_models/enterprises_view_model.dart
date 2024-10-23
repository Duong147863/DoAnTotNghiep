import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/enterprises_model.dart';
import 'package:nloffice_hrm/repository/enterprises_repo.dart';

class EnterprisesViewModel extends ChangeNotifier {
  final EnterprisesRepository repository = EnterprisesRepository();

  List<Enterprises> _list = [];
  bool fetchingData = false;
  List<Enterprises> get listEnterprises => _list;

  Future<void> fetchAllEnterprises() async {
    fetchingData = true;
    try {
      _list = await repository.fetchAllEnterprises();
    } catch (e) {
      throw Exception('Failed to load datas: $e');
    }
    fetchingData = false;
  }
}
