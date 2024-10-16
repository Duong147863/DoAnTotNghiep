import 'dart:convert';

import 'package:nloffice_hrm/api_services/project_service.dart';
import 'package:nloffice_hrm/models/projects_model.dart';

class ProjectsRepository {
  final ProjectService service = ProjectService();

  Future<List<Projects>> fetchAllProjectsOf(int enterpriseID) async {
    final response = await service.getProjectsByEnterpriseID(enterpriseID);

    if (response.statusCode == 200) {
      return List<Projects>.from(
          json.decode(response.body).map((x) => Projects.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
