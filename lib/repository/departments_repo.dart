import 'dart:convert';

import 'package:nloffice_hrm/api_services/department_service.dart';
import 'package:nloffice_hrm/models/departments_model.dart';

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
  Future<bool> updateDepartment(Departments department) async {
  try {
    final response = await service.updateDepartment(department); 
    if (response.statusCode == 200) {
      print("Update successful. Response body: ${response.body}");
      return true; // Cập nhật thành công
    } else {
      print("Failed to update department: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to update department');
    }
  } catch (error) {
    print("An error occurred: $error");
    throw Exception('Failed to update profile');
  }
}
}
