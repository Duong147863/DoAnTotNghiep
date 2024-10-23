import 'package:flutter/material.dart';
import 'package:nloffice_hrm/repository/projects_repo.dart';

class ProjectsViewModel extends ChangeNotifier {
  final ProjectsRepository repository = ProjectsRepository();
}
