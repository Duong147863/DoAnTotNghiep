import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/working.processes_model.dart';
import 'package:nloffice_hrm/repository/workingprocess_repo.dart';

class WorkingprocessesViewModel extends ChangeNotifier {
  final WorkingprocessRepository repository = WorkingprocessRepository();

  List<WorkingProcesses> _list = [];
  bool fetchingData = false;
  List<WorkingProcesses> get listWorkingProcess => _list;

  Future<void> fetchWorkingProcess(int profileID) async {
    fetchingData = true;
    try {
      _list = await repository.fetchWorkingProcessesOf(profileID);
    } catch (e) {
      throw Exception('Failed to load datas: $e');
    }
    fetchingData = false;
  }
}
