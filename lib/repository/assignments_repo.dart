import 'dart:convert';

import 'package:nloffice_hrm/api_services/assignments_services.dart';
import 'package:nloffice_hrm/models/assignments_model.dart';

class AssignmentsRepository {
  final AssignmentsServices service = AssignmentsServices();

  Future<List<Assignments>> getAssignmentsDetails(String projectId) async {
    try {
      final response = await service.getAssignmentsDetails(projectId);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<Assignments> assignments = jsonResponse
            .map((assignmentJson) => Assignments.fromJson(assignmentJson))
            .toList();
        return assignments;
      } else {
        print("Failed to delete Relative: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to load assignments details');
      }
    } catch (error) {
      print("Error: $error");

      throw Exception('Failed to load assignments details');
    }
  }

  Future<bool> createNewAssignments(Assignments assignmeents) async {
    final response = await service.createNewAssignments(assignmeents);
    if (response.statusCode == 200) {
      return true;
    } else {
      print("Failed to delete Relative: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to add profile: ${response.statusCode}');
    }
  }

  Future<bool> updateAssignments(Assignments assignmeents) async {
    try {
      final response = await service.updateAssignments(assignmeents);
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

  Future<bool> deleteAssignments(int assignmeentsId) async {
    try {
      final response = await service.deleteAssignments(assignmeentsId);
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete Relative: ${response.statusCode}");
        print("Response body: ${response.body}");
        return false;
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to delete Relative');
    }
  }
}
