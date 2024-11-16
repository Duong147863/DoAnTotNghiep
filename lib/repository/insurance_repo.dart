import 'dart:convert';

import 'package:nloffice_hrm/api_services/insurance_services.dart';
import 'package:nloffice_hrm/models/insurance_model.dart';
class InsuranceRepository {
  final InsuranceServices service = InsuranceServices();
  Future<List<Insurance>> getInsurancesOf(String profileID) async {
    final response = await service.getInsurancesOf(profileID);

    if (response.statusCode == 200) {
      print("Load successful. Response body: ${response.body}");

      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map((x) => Insurance.fromJson(x)).toList();
    } else {
      print("Failed to load Trainingprocesses: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load data');
    }
  }

  Future<bool> createNewInsurances(Insurance insurance) async {
    final response = await service.createNewInsurances(insurance);
    if (response.statusCode == 200) {
      return true;
    } else {
      print("Failed to add profile: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to add diploma: ${response.statusCode}');
    }
  }

  Future<bool> updateInsurances(Insurance insurance) async {
    try {
      final response = await service.updateInsurances(insurance);
      if (response.statusCode == 200) {
        print("Update successful. Response body: ${response.body}");
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

  Future<bool> deleteInsurances(String insurancesId) async {
    try {
      final response = await service.deleteInsurances(insurancesId);
      if (response.statusCode == 200) {
        print("Delete successful. Response body: ${response.body}");
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