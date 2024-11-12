import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/projects_model.dart';

class ProjectService {
  Future<http.Response> getAllProject() async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}projects'), headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
    });
  }

  Future<http.Response> createNewProject(Projects projects) async {
    return await http.post(Uri.parse('${AppStrings.baseUrlApi}project/create'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(projects.toJson()));
  }

  Future<http.Response> updateProject(Projects projects) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}project/update'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(projects.toJson()),
    );
  }

  Future<http.Response> deleteProject(String projectid) async {
    return await http.delete(
      Uri.parse('${AppStrings.baseUrlApi}project/delete/$projectid'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Accept': 'application/json',
      },
    );
  }
}
