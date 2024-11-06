import 'dart:convert';

import 'package:nloffice_hrm/api_services/salary_service.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';

class SalariesRepository {
  final SalaryService service = SalaryService();

  Future<List<Salaries>> fetchAllSalariesByEnterpriseID(
      int enterpriseID) async {
    final response = await service.getAllSalariesByEnterpriseID(enterpriseID);

    if (response.statusCode == 200) {
      return List<Salaries>.from(
          json.decode(response.body).map((x) => Salaries.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }
   Future<bool> addSalary(Salaries salary) async {
    final response = await service.addNewSalary(salary);
    if (response.statusCode == 200) {
      print("add successful. Response body: ${response.body}");
      return true;
    } else {
      print("Failed to add profile: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to add profile: ${response.statusCode}');
    }
  }
   Future<bool> updateSalary(Salaries salary) async {
    try {
      final response = await service.updateSalary(salary);
      if (response.statusCode == 200) {
        print("Update successful. Response body: ${response.body}");
        return true;
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
