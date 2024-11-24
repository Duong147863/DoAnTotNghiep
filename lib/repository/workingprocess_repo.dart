import 'dart:convert';

import 'package:nloffice_hrm/api_services/workingprocess_service.dart';
import 'package:nloffice_hrm/models/working.processes_model.dart';

class WorkingprocessRepository {
  final WorkingprocessService service = WorkingprocessService();

  Future<List<WorkingProcesses>> fetchWorkingProcessesOf(
      String profileID) async {
    final response = await service.getWorkingProcessOf(profileID);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map((x) => WorkingProcesses.fromJson(x)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> createNewWorkingprocess(WorkingProcesses workingprocess) async {
    final response = await service.createNewWorkingprocess(workingprocess);
    if (response.statusCode == 200 || response.statusCode == 201) {
         print("Delete successful. Response body: ${response.body}");
      return true;
    } else {
              print("Failed to delete Relative: ${response.statusCode}");
        print("Response body: ${response.body}");
      throw Exception('Failed to add WorkingProcesses: ${response.body}');
    }
  }

  Future<bool> updateWorkingprocess(WorkingProcesses workingprocess) async {
    try {
      final response = await service.updateWorkingprocess(workingprocess);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update WorkingProcesses');
      }
    } catch (error) {
      throw Exception('Failed to update WorkingProcesses');
    }
  }

  Future<bool> deleteWorkingprocess(String workingprocessId) async {
    try {
      final response = await service.deleteWorkingprocess(workingprocessId);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete Workingprocess');
      }
    } catch (error) {
      throw Exception('Failed to delete Workingprocess');
    }
  }
}
