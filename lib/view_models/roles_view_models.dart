import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/roles_model.dart';
import 'package:nloffice_hrm/repository/roles_repo.dart';

class RolesViewModels extends ChangeNotifier {
  final RolesRepository repository = RolesRepository();
  List<Roles> allRoles = [];
  List<Roles> get listRoles => allRoles;
  bool fetchingData = false;
  Future<void> getAllRoles() async {
    fetchingData = true;
    try {
      allRoles = await repository.getAllRoles();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load profiles: $e');
    }
    fetchingData = false;
  }
}
