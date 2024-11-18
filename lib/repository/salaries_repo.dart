import 'dart:convert';

import 'package:nloffice_hrm/api_services/salary_service.dart';
import 'package:nloffice_hrm/models/getSalarySlip.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';

class SalariesRepository {
  final SalaryService service = SalaryService();

   Future<List<Getsalaryslip>> getSalaryDetails(String salaryId) async {
  try {
    final response = await service.getAllSalariesByProfileID(salaryId);

    if (response.statusCode == 200) {
      print("load successful. Response body: ${response.body}");
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Getsalaryslip> salaryId = jsonResponse
          .map((SalaryJson) => Getsalaryslip.fromJson(SalaryJson))
          .toList();
      return salaryId;
    } else {
      print("Failed to delete Relative: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load assignments details');
    }
  } catch (error) {
    print("Error: $error");
    
    throw Exception('Failed to load assignments details');
  }
}
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
  Future<List<Salaries>> fetchAllSalaries() async {
    final response = await service.getAllSalaries();

    if (response.statusCode == 200) {
      return List<Salaries>.from(
          json.decode(response.body).map((x) => Salaries.fromJson(x)));
    } else {;
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
   Future<bool> deleteSalary(String salaryId) async {
    try {
      final response = await service.deleteSalary(salaryId);
      if (response.statusCode == 200) {
        print("Delete successful. Response body: ${response.body}");
        return true;
      } else {
        print("Failed to delete Salary: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to delete Salary');
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to delete Salary');
    }
  }
    Future<List<Profiles>> getAllSalariesByProfileID(
      String profileId) async {
    final response = await service.getAllSalariesByProfileID(profileId);

    if (response.statusCode == 200) {
      print("Load successful. Response body: ${response.body}");

      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map((x) => Profiles.fromJson(x)).toList();
    } else {
      print("Failed to load Profiles: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load data');
    }
  }
}
