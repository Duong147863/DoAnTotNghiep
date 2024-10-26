import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';

class SalaryService {
  Future<http.Response> getAllSalariesByEnterpriseID(int enterpriseID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}salaries/$enterpriseID'));
  }

  Future<http.Response> addNewSalary(Salaries salary) async {
    return await http.post(Uri.parse('${AppStrings.baseUrlApi}salary/create'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(salary.toJson()));
  }
}
