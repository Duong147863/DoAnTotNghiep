import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/tasks_model.dart';
class TaskServices {
  Future<http.Response> getAllTask() async {
    return await http.get(
        Uri.parse('${AppStrings.baseUrlApi}project/task'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
        });
  }

  Future<http.Response> createNewTask(Tasks task) async {
    return await http.post(
        Uri.parse('${AppStrings.baseUrlApi}project/task/create'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(task.toJson()));
  }
  Future<http.Response> updateTask(Tasks task) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}project/task/update'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(task.toJson()),
    );
  }
  Future<http.Response> deleteTask(int taskId) async {
    return await http.delete(
      Uri.parse('${AppStrings.baseUrlApi}project/task/delete/$taskId'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Accept': 'application/json',
      },
    );
  }
}