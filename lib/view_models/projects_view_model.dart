import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/projects_model.dart';
import 'package:nloffice_hrm/repository/projects_repo.dart';

class ProjectsViewModel extends ChangeNotifier {
  final ProjectsRepository repository = ProjectsRepository();
  List<Projects> _list = [];
  bool fetchingData = false;
  List<Projects> get listProjects => _list;

  Future<void> getAllProject() async {
    fetchingData = true;
    notifyListeners();
    try {
      _list = await repository.getAllProject();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }

  Future<void> addNewProject(Projects projects) async {
    try {
      await repository.addProject(projects);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create data: $e');
    }
  }

  Future<void> updateProject(Projects projects) async {
    try {
      await repository.updatedProject(projects);

      int index =
          _list.indexWhere((pro) => pro.projectId == projects.projectId);
      if (index != -1) {
        _list[index] = projects;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update project: $e');
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      bool success = await repository.deletePosition(projectId);
      if (success) {
        _list.removeWhere((pro) => pro.projectId == projectId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete project');
      }
    } catch (e) {
      throw Exception('Failed to delete project: $e');
    }
  }
}
