import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/trainingprocesses_model.dart';
class TrainingprocessesService {
    Future<http.Response> getTrainingProcessesOf(String profileID) async {
    return await http.get(
        Uri.parse('${AppStrings.baseUrlApi}profile/trainingProcesses/$profileID'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
        });
  }
  Future<http.Response> createTrainingProcesses(Trainingprocesses trainingprocesses,Function(String) callback) async {
    return await http.post(
        Uri.parse('${AppStrings.baseUrlApi}profile/trainingProcesses/add'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(trainingprocesses.toJson()));
  }
  Future<http.Response>updateTrainingProcesses(Trainingprocesses trainingprocesses) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}profile/trainingProcesses/update'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(trainingprocesses.toJson()),
    );
  }
  Future<http.Response> deleteTrainingProcesses(int trainingprocessesId) async {
    return await http.delete(
      Uri.parse('${AppStrings.baseUrlApi}profile/trainingProcesses/delete/$trainingprocessesId'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Accept': 'application/json',
      },
    );
  }
}