import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/absents_model.dart';
import 'package:nloffice_hrm/models/departments_model.dart';
import 'package:nloffice_hrm/repository/absent_repo.dart';

class AbsentsViewModel extends ChangeNotifier {
  final AbsentsRepository repository = AbsentsRepository();

  bool fetchingData = false;
  List<Absents> _list = [];
  List<Absents> get listAbsents => _list;

  Future<void> addNewAbsent(Absents absents) async {
    try {
      await repository.addNewAbsent(absents);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add absent: $e');
    }
  }
}
