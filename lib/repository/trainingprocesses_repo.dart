import 'dart:convert';

import 'package:nloffice_hrm/api_services/trainingprocesses_service.dart';
import 'package:nloffice_hrm/models/trainingprocesses_model.dart';

class TrainingprocessesRepository {
  final TrainingprocessesService service = TrainingprocessesService();

  Future<List<Trainingprocesses>> getTrainingProcessesOf(
      String profileID) async {
    final response = await service.getTrainingProcessesOf(profileID);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map((x) => Trainingprocesses.fromJson(x)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> createTrainingProcesses(
      Trainingprocesses trainingprocesses) async {
    final response = await service.createTrainingProcesses(trainingprocesses);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to add Trainingprocesses: ${response.statusCode}');
    }
  }

  Future<bool> updateTrainingProcesses(
      Trainingprocesses trainingprocesses) async {
    try {
      final response = await service.updateTrainingProcesses(trainingprocesses);
      if (response.statusCode == 200) {
        print("Delete successful. Response body: ${response.body}");
        return true;
      } else {
          print("Failed to delete Relative: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to update Trainingprocesses');
      }
    } catch (error) {
      throw Exception('Failed to update Trainingprocesses');
    }
  }

  Future<bool> deleteTrainingProcesses(String trainingprocessesId) async {
    try {
      final response =
          await service.deleteTrainingProcesses(trainingprocessesId);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete Trainingprocesses');
      }
    } catch (error) {
      throw Exception('Failed to delete Trainingprocesses');
    }
  }
}
