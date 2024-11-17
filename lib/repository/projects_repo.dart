import 'dart:convert';

import 'package:nloffice_hrm/api_services/project_service.dart';
import 'package:nloffice_hrm/models/projects_model.dart';

class ProjectsRepository {
  final ProjectService service = ProjectService();

  Future<List<Projects>> getAllProject() async {
    final response = await service.getAllProject();

    if (response.statusCode == 200) {
      return List<Projects>.from(
          json.decode(response.body).map((x) => Projects.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> addProject(Projects projects) async {
    final response = await service.createNewProject(projects);
    if (response.statusCode == 200) {
      print("Add successful. Response body: ${response.body}");
      return true;
    } else {
      print("Failed to Add Project: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to add Project: ${response.statusCode}');
    }
  }

  Future<bool> updatedProject(Projects projects) async {
    try {
      final response = await service.updateProject(projects);
      if (response.statusCode == 200) {
        print("Update successful. Response body: ${response.body}");
        return true;
      } else {
        print("Failed to update project: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to update project');
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to update project');
    }
  }

  Future<bool> deletePosition(String projectId) async {
    try {
      final response = await service.deleteProject(projectId);
      if (response.statusCode == 200) {
        print("Delete successful. Response body: ${response.body}");
        return true;
      } else {
        print("Failed to delete project: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to delete project');
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to delete project');
    }
  }
}
