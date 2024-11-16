import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/tasks_model.dart';
import 'package:nloffice_hrm/repository/task_repo.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository repository = TaskRepository();
  List<Tasks> _list = [];
  bool fetchingData = false;
  List<Tasks> get listTasks => _list;

  Future<void> getAllTask() async {
    fetchingData = true;
    notifyListeners();
    try {
      _list = await repository.getAllTask();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }

  Future<void> createNewTask(Tasks task) async {
    try {
      await repository.createNewTask(task);
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }

  Future<void> updateTask(Tasks task) async {
    try {
      await repository.updateTask(task);

      int index =
          _list.indexWhere((tas) => tas.taskId == task.taskId);
      if (index != -1) {
        _list[index] = task;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update relatives: $e');
    }
  }
    Future<void> deleteTask(int taskId) async {
    try {
      bool success = await repository.deleteTask(taskId);
      if (success) {
        _list.removeWhere((tas) => tas.taskId == taskId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete relatives');
      }
    } catch (e) {
      throw Exception('Failed to delete relatives: $e');
    }
  }
}