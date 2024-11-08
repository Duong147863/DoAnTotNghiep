import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/api_services/salary_service.dart';
import 'package:nloffice_hrm/models/positions_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';
import 'package:nloffice_hrm/repository/salaries_repo.dart';

class SalariesViewModel extends ChangeNotifier {
  final SalariesRepository repository = SalariesRepository();
  List<Salaries> _list = [];
  bool fetchingData = false;
  List<Salaries> get listSalaries => _list;
  late Salaries _salary;

  Salaries get salary => _salary;
  Future<void> fetchAllSalariesEnter(int enterpriseID) async {
    fetchingData = true;
    try {
      _list = await repository.fetchAllSalariesByEnterpriseID(enterpriseID);
    } catch (e) {
      throw Exception('Failed to load datas: $e');
    }
    fetchingData = false;
  }

  Future<void> fetchAllSalaries() async {
    fetchingData = true;
    notifyListeners();
    try {
      _list = await repository.fetchAllSalaries();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }

  Future<void> addSalary(Salaries salary) async {
    try {
      await repository.addSalary(salary);
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }

  Future<void> updateSalary(Salaries salary) async {
    try {
      await repository.updateSalary(salary);
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }
}
