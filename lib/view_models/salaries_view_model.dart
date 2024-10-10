import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';
import 'package:nloffice_hrm/repository/salaries_repo.dart';

class SalariesViewModel extends ChangeNotifier {
  final SalariesRepository repository = SalariesRepository();

  List<Salaries> _list = [];
  bool fetchingData = false;
  List<Salaries> get listSalaries => _list;

  Future<void> fetchAllSalaries(int enterpriseID) async {
    fetchingData = true;
    try {
      _list = await repository.fetchAllSalariesByEnterpriseID(enterpriseID);
    } catch (e) {
      throw Exception('Failed to load datas: $e');
    }
    fetchingData = false;
  }
}
