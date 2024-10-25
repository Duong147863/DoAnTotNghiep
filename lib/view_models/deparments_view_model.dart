import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/repository/departments_repo.dart';

class DeparmentsViewModel extends ChangeNotifier {
  final DepartmentsRepository repository = DepartmentsRepository();

  List<Departments> _list = [];
  bool fetchingData = false;
  List<Departments> get listDepartments => _list;

  Future<void> fetchAllDepartments() async {
    fetchingData = true;
    try {
      _list = await repository.fetchAllDepartments();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load datas: $e');
    }
    fetchingData = false;
  }
}
