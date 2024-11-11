import 'dart:convert';

import 'package:nloffice_hrm/api_services/relative_service.dart';
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';

class RelativesRepository {
  final RelativeService service = RelativeService();

  Future<List<Relatives>> fetchAllRelatives(String profileId) async {
    final response = await service.getAllRelative(profileId);

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return List<Relatives>.from(
          json.decode(response.body).map((x) => Relatives.fromJson(x)),
        );
      } else {
        return []; // Return an empty list if no data is returned
      }
    } else {
      throw Exception('Failed to load absents: ${response.statusCode}');
    }
  }

  Future<bool> addRelative(Relatives relatives) async {
    final response = await service.createNewRelative(relatives);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to add profile: ${response.statusCode}');
    }
  }

  Future<bool> updatedRelatives(Relatives relatives) async {
    try {
      final response = await service.updateRelative(relatives);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update department');
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to update profile');
    }
  }
    Future<bool> deleteRelative(String profileID) async {
    try {
      final response = await service.deleteRelative(profileID);
      if (response.statusCode == 200) {
        print("Delete successful. Response body: ${response.body}");
        return true;
      } else {
        print("Failed to delete Relative: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to delete Relative');
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to delete Relative');
    }
  }
}
