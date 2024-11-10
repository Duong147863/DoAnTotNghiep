import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/enterprises_model.dart';
import 'package:nloffice_hrm/repository/enterprises_repo.dart';

class EnterprisesViewModel extends ChangeNotifier {
  final EnterprisesRepository repository = EnterprisesRepository();

  bool fetchingData = false;

  Future<void> fetchEnterpriseInfo() async {
    fetchingData = true;
    try {
      await repository.fetchEnterpriseInfo();
    } catch (e) {
      throw Exception('Failed to load datas: $e');
    }
    fetchingData = false;
  }
}
