import 'dart:convert';

import 'package:nloffice_hrm/api_services/hirings_model.dart';
import 'package:nloffice_hrm/models/hirings_model.dart';

class HiringsRepository {
  final HiringsModel service = HiringsModel();
  Future<bool> createNewHirings(Hirings hirings) async {
    final response = await service.createNewHirings(hirings);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Add successful. Response body: ${response.body}");
      return true;
    } else {
      print("Failed to Add Relative: ${response.statusCode}");
        print("Response body: ${response.body}");
      throw Exception('Failed to add profile: ${response.statusCode}');
    }
  }

  Future<List<Hirings>> getAllHirings() async {
    final response = await service.getAllHirings();
    if (response.statusCode == 200) {
      return List<Hirings>.from(
        json.decode(response.body).map((x) => Hirings.fromJson(x)),
      );
    } else {
      throw Exception('Failed to load absents: ${response.statusCode}');
    }
  }

  Future<bool> updateHirings(Hirings hirings) async {
    try {
      final response = await service.updateHirings(hirings);
      if (response.statusCode == 200) {
          print("Add successful. Response body: ${response.body}");
        return true;
      } else {
         print("Failed to Add Relative: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to update Trainingprocesses');
      }
    } catch (error) {
      throw Exception('Failed to update Trainingprocesses');
    }
  }
}
