import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';

class SalaryService {
  Future<http.Response> getAllSalariesByEnterpriseID(int enterpriseID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}salaries/$enterpriseID'));
  }

  Future<http.Response> getAllSalaries() async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}salaries'), headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
    });
  }
  Future<http.Response> getAllSalariesByProfileID(String profileId) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}salary/$profileId'), headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
    });
  }

  Future<http.Response> addNewSalary(Salaries salary) async {
    return await http.post(Uri.parse('${AppStrings.baseUrlApi}salary/create'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(salary.toJson()));
  }

  Future<http.Response> updateSalary(Salaries salary) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}salary/update'),
      headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(salary.toJson()),
    );
  }
   Future<http.Response> deleteSalary(String salaryId) async {
    return await http.delete(
      Uri.parse('${AppStrings.baseUrlApi}salary/delete/$salaryId'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Accept': 'application/json',
      },
    );
  }
}
