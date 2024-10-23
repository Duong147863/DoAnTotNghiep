import 'dart:convert';

import 'package:nloffice_hrm/api_services/workingprocess_service.dart';
import 'package:nloffice_hrm/models/working.processes_model.dart';

class WorkingprocessRepository {
  final WorkingprocessService service = WorkingprocessService();

  Future<List<WorkingProcesses>> fetchWorkingProcessesOf(int profileID) async {
    final response = await service.getWorkingProcessOf(profileID);

    if (response.statusCode == 200) {
      return List<WorkingProcesses>.from(
          json.decode(response.body).map((x) => WorkingProcesses.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
