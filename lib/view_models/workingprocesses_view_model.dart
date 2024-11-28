import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/working.processes_model.dart';
import 'package:nloffice_hrm/repository/workingprocess_repo.dart';

class WorkingprocessesViewModel extends ChangeNotifier {
  final WorkingprocessRepository repository = WorkingprocessRepository();

  List<WorkingProcesses> _list = [];
  bool fetchingData = false;
  List<WorkingProcesses> get listWorkingProcess => _list;

  Future<void> fetchWorkingProcess(String profileID) async {
    try {
      List<WorkingProcesses> workingProcessesList =
          await repository.fetchWorkingProcessesOf(profileID);
      _list = workingProcessesList
          .where((workingProcess) => workingProcess.profileId == profileID)
          .toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load working processes: $e');
    }
  }

  Future<void> createNewWorkingprocess(
      WorkingProcesses workingprocess, Function(String) callback) async {
    try {
      await repository.createNewWorkingprocess(
          workingprocess, callback); // Call the repository method
    } catch (e) {
      callback(
          'Failed to add relative: $e'); // Call the callback with error message
    }
  }

    Future<void> updateWorkingprocess(WorkingProcesses workingprocess, Function(String) callback) async {
    try {
      await repository.updateWorkingprocess(workingprocess,callback);
      int index =
          _list.indexWhere((wor) => wor.workingprocessId == workingprocess.workingprocessId);
      if (index != -1) {
        _list[index] = workingprocess;
        notifyListeners();
      }
    } catch (e) {
      callback('Failed to add relative: $e');  // Call the callback with error message
    }
  }
  Future<void> deleteWorkingprocess(int workingprocessId) async {
    try {
      bool success = await repository.deleteWorkingprocess(workingprocessId);
      if (success) {
        _list.removeWhere((wor) => wor.workingprocessId == workingprocessId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete Workingprocess');
      }
    } catch (e) {
      throw Exception('Failed to delete Workingprocess: $e');
    }
  }
}
