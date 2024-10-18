import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/departments_model.dart';

class DepartmentService{
  Future<http.Response> getAllDepartmentsByEnterpriseID(int enterpriseID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}departments/$enterpriseID'));
  }

  Future<http.Response> createNewDepartment() async {
    return await http.post(Uri.parse(''));
  }

  Future<http.Response> updateExistedDepartment() async {
    return await http.put(Uri.parse(''));
  }

}
