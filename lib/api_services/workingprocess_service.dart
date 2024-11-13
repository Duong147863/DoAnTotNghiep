import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/working.processes_model.dart';

class WorkingprocessService{
   Future<http.Response> getWorkingProcessOf(String profileID) async {
    return await http.get(
        Uri.parse('${AppStrings.baseUrlApi}profile/workingprocesses/$profileID'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
        });
  }
  Future<http.Response> createNewWorkingprocess(WorkingProcesses workingprocess) async {
    return await http.post(
        Uri.parse('${AppStrings.baseUrlApi}profile/workingprocesses/add'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(workingprocess.toJson()));
  }
  Future<http.Response>updateWorkingprocess(WorkingProcesses workingprocess) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}profile/workingprocesses/update'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(workingprocess.toJson()),
    );
  }
  Future<http.Response> deleteWorkingprocess(String workingprocessId) async {
    return await http.delete(
      Uri.parse('${AppStrings.baseUrlApi}profile/workingprocesses/delete/$workingprocessId'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Accept': 'application/json',
      },
    );
  }
}