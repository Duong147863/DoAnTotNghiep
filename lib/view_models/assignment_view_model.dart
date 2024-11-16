import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/assignments_model.dart';
import 'package:nloffice_hrm/repository/assignments_repo.dart';

class AssignmentsViewModel extends ChangeNotifier {
  final AssignmentsRepository repository = AssignmentsRepository();

  List<Assignments> _list = [];
  bool fetchingData = false;
  List<Assignments> get listAssignments => _list;

  Future<void> createNewAssignments(Assignments assignmeents) async {
    try {
      await repository.createNewAssignments(assignmeents);
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }

  Future<void> updateAssignments(Assignments assignmeents) async {
    try {
      await repository.updateAssignments(assignmeents);

      int index =
          _list.indexWhere((assi) => assi.assignmentId == assignmeents.assignmentId);
      if (index != -1) {
        _list[index] = assignmeents;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update relatives: $e');
    }
  }
    Future<void> deleteRelative(int assignmeentsId) async {
    try {
      bool success = await repository.deleteAssignments(assignmeentsId);
      if (success) {
        _list.removeWhere((assi) => assi.assignmentId == assignmeentsId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete relatives');
      }
    } catch (e) {
      throw Exception('Failed to delete relatives: $e');
    }
  }
}