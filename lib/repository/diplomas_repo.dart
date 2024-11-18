import 'dart:convert';

import 'package:nloffice_hrm/api_services/diploma_service.dart';
import 'package:nloffice_hrm/models/diplomas_model.dart';

class DiplomasRepository {
  final DiplomaService service = DiplomaService();

  Future<List<Diplomas>> getDiplomasOf(String profileID) async {
    final response = await service.getDiplomaOf(profileID);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map((x) => Diplomas.fromJson(x)).toList();
    } else {
      print("Failed to load Trainingprocesses: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load data');
    }
  }

  Future<bool> AddDiplomas(Diplomas diploma) async {
    final response = await service.createNewDiploma(diploma);
    if (response.statusCode == 200) {
      return true;
    } else {
      print("Failed to add profile: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to add diploma: ${response.statusCode}');
    }
  }

  Future<bool> updateDiplomas(Diplomas diploma) async {
    try {
      final response = await service.updateDiplomas(diploma);
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to Update Trainingprocesses: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to update Trainingprocesses');
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to update Trainingprocesses');
    }
  }

  Future<bool> deleteDiplomas(String diplomas) async {
    try {
      final response = await service.deleteDiplomas(diplomas);
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete Trainingprocesses: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to delete Trainingprocesses');
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to delete Trainingprocesses');
    }
  }
}
