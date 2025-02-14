import 'dart:convert';

import 'package:nloffice_hrm/api_services/department_service.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/department_position_model.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DepartmentsRepository {
  final DepartmentService service = DepartmentService();

  Future<List<Departments>> fetchAllDepartments() async {
    final response = await service.getAllDepartments();

    if (response.statusCode == 200) {
      return List<Departments>.from(
          json.decode(response.body).map((x) => Departments.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<DepartmentPosition>> getDepartmentsByPosition() async {
    final response = await service.getDepartmentsByPosition();

    if (response.statusCode == 200) {
      ;
      return List<DepartmentPosition>.from(json
          .decode(response.body)
          .map((x) => DepartmentPosition.fromJson(x)));
    } else {
      throw Exception('Failed to load departmen and position 1');
    }
  }

  Future<bool> addNewDepartment(Departments department) async {
    try {
      final response = await service.createNewDepartment(department);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to add department');
      }
    } catch (error) {
      throw Exception('Failed to add department');
    }
  }

  Future<bool> updateDepartment(Departments department) async {
    try {
      final response = await service.updateDepartment(department);
      if (response.statusCode == 200) {
        print("Update successful. Response body: ${response.body}");
        return true;
      } else {
        print("Failed to update: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to update department');
      }
    } catch (error) {
      throw Exception('Failed to update department');
    }
  }

  Future<bool> deleteDepartment(String departmentId) async {
    try {
      final response = await service.deleteDepartment(departmentId);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete department');
      }
    } catch (error) {
      throw Exception('Failed to delete department');
    }
  }
}
