import 'dart:convert';

import 'package:nloffice_hrm/api_services/task_services.dart';
import 'package:nloffice_hrm/models/tasks_model.dart';
class TaskRepository {
   final TaskServices service = TaskServices();
    Future<List<Tasks>> getAllTask() async {
    final response = await service.getAllTask();

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
           print("Delete successful. Response body: ${response.body}");
        return List<Tasks>.from(
          json.decode(response.body).map((x) => Tasks.fromJson(x)),
        );
      } else {
          print("Failed to delete Relative: ${response.statusCode}");
      print("Response body: ${response.body}");
        return []; // Return an empty list if no data is returned
      }
    } else {
        print("Failed to delete Relative: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load absents: ${response.statusCode}');
    }
  }

  Future<bool> createNewTask(Tasks task) async {
    final response = await service.createNewTask(task);
    if (response.statusCode == 200) {
      print("Delete successful. Response body: ${response.body}");
      return true;
    } else {
      print("Failed to delete Relative: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to add profile: ${response.statusCode}');
    }
  }

  Future<bool> updateTask(Tasks task) async {
    try {
      final response = await service.updateTask(task);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update department');
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to update profile');
    }
  }

  Future<bool> deleteTask(int taskId) async {
    try {
      final response = await service.deleteTask(taskId);
      if (response.statusCode == 200) {
        print("Delete successful. Response body: ${response.body}");
        return true;
      } else {
        print("Failed to delete Relative: ${response.statusCode}");
        print("Response body: ${response.body}");
        return false; 
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to delete Relative');
    }
  }
}