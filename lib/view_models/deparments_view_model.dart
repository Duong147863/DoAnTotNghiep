import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/repository/departments_repo.dart';

class DeparmentsViewModel extends ChangeNotifier {
  final DepartmentsRepository repository = DepartmentsRepository();

  bool fetchingData = false;
  List<Departments> _list = [];
  List<Departments> get listDepartments => _list;

  // Lấy tất cả phòng ban
  Future<void> fetchAllDepartments() async {
    fetchingData = true;
    notifyListeners();
    try {
      _list = await repository.fetchAllDepartments();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }

  Future<void> addNewDepartment(Departments department) async {
    try {
      await repository.addNewDepartment(department);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update department: $e');
    }
  }

  Future<void> updateDepartment(Departments department) async {
    try {
      await repository.updateDepartment(department);
      int index = _list
          .indexWhere((dep) => dep.departmentID == department.departmentID);
      if (index != -1) {
        _list[index] = department;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update department: $e');
    }
  }

  Future<void> deleteDepartment(String departmentId) async {
    try {
      bool success = await repository.deleteDepartment(departmentId);
      if (success) {
        _list.removeWhere(
            (department) => department.departmentID == departmentId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete position');
      }
    } catch (e) {
      throw Exception('Failed to delete position: $e');
    }
  }
}
