import 'dart:convert';

import 'package:nloffice_hrm/api_services/task_services.dart';
import 'package:nloffice_hrm/models/tasks_model.dart';

class TaskRepository {
  final TaskServices service = TaskServices();
  Future<List<Tasks>> getAllTask() async {
    final response = await service.getAllTask();

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return List<Tasks>.from(
          json.decode(response.body).map((x) => Tasks.fromJson(x)),
        );
      } else {
        return []; // Return an empty list if no data is returned
      }
    } else {
      throw Exception('Failed to load absents: ${response.statusCode}');
    }
  }

  Future<bool> createNewTask(Tasks task) async {
    final response = await service.createNewTask(task);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
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
      throw Exception('Failed to update profile');
    }
  }

  Future<bool> deleteTask(int taskId) async {
    try {
      final response = await service.deleteTask(taskId);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false; 
      }
    } catch (error) {
      throw Exception('Failed to delete Relative');
    }
  }
}
