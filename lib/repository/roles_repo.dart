import 'dart:convert';

import 'package:nloffice_hrm/api_services/roles_services.dart';
import 'package:nloffice_hrm/models/roles_model.dart';

class RolesRepository {
  final RolesServices service = RolesServices();
    Future<List<Roles>> getAllRoles() async {
    final response = await service.getAllRoles();
    if (response.statusCode == 200) {
      return List<Roles>.from(
          json.decode(response.body).map((x) => Roles.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }
}