import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/getSalarySlip.dart';
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
   List<Getsalaryslip> _listGetsalaryslip = [];
  List<Getsalaryslip> get GetsalaryslipList => _listGetsalaryslip;
  Salaries get salary => _salary;

    Future<void> getSalaryDetails(String salaryId) async {
    try {
      fetchingData = true;
      notifyListeners();
      List<Getsalaryslip> salary = await repository.getSalaryDetails(salaryId);
      _listGetsalaryslip = salary;
      fetchingData = false;
      notifyListeners();
    } catch (e) {
      fetchingData = false;
      notifyListeners();
      throw Exception('Failed to load assignments details: $e');
    }
  }
  Future<void> fetchAllSalariesEnter(int enterpriseID) async {
    fetchingData = true;
    try {
      _list = await repository.fetchAllSalariesByEnterpriseID(enterpriseID);
    } catch (e) {
      throw Exception('Failed to load datas: $e');
    }
    fetchingData = false;
  }

  // Fetch all salaries and update the list
  Future<void> fetchAllSalaries() async {
    fetchingData = true;
    notifyListeners(); // Notify to show loader or loading state
    try {
      _list = await repository.fetchAllSalaries();
    } catch (e) {
      print("Error loading salaries: $e");
      // Handle error appropriately, maybe notify the UI about the failure
      throw Exception('Failed to load salaries data: $e');
    } finally {
      fetchingData = false;
      notifyListeners(); // Notify to hide loader or loading state
    }
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
      int index = _list.indexWhere((sal) => sal.salaryId == salary.salaryId);
      if (index != -1) {
        _list[index] = salary;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }
  Future<void> deleteSalary(String salaryId) async {
    try {
      bool success = await repository.deleteSalary(salaryId);
      if (success) {
        _list.removeWhere((sal) => sal.salaryId == salaryId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete Salary');
      }
    } catch (e) {
      throw Exception('Failed to delete Salary: $e');
    }
  }
}
