import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/departments_model.dart';

class DepartmentService {
  Future<http.Response> getAllDepartments() async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}departments'), headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
    });
  }

  Future<http.Response> createNewDepartment(
    Departments department,
  ) async {
    return await http.post(
        Uri.parse('${AppStrings.baseUrlApi}department/create'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(department.toJson()));
  }

  Future<http.Response> updateDepartment(Departments department) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}department/update'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(department.toJson()),
    );
  }

  Future<http.Response> deleteDepartment(String departmentId) async {
    return await http.delete(
      Uri.parse('${AppStrings.baseUrlApi}department/delete/$departmentId'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Accept': 'application/json',
      },
    );
  }
}
