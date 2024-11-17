import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/assignments_model.dart';
class AssignmentsServices {
    Future<http.Response> getAssignmentsDetails() async {
    return await http.get(
        Uri.parse('${AppStrings.baseUrlApi}assign/task'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
        });
  }
  Future<http.Response> createNewAssignments(Assignments assignmeents) async {
    return await http.post(
        Uri.parse('${AppStrings.baseUrlApi}assign/create'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(assignmeents.toJson()));
  }
  Future<http.Response> updateAssignments(Assignments assignmeents) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}assign/update'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(assignmeents.toJson()),
    );
  }
  Future<http.Response> deleteAssignments(int assignmeentsId) async {
    return await http.delete(
      Uri.parse('${AppStrings.baseUrlApi}assign/delete/$assignmeentsId'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Accept': 'application/json',
      },
    );
  }

}