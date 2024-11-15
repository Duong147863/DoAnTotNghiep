import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/timekeepings_model.dart';
import 'package:nloffice_hrm/repository/time_attendance_repo.dart';

class TimeKeepingViewModel extends ChangeNotifier {
  final TimekeepingRepo repository = TimekeepingRepo();

  List<Timekeepings> _list = [];
  bool fetchingData = false;
  List<Timekeepings> get listTrainingprocesses => _list;

  Future<void> checkin(Timekeepings trainingprocesses) async {
    try {
      await repository.checkIn(trainingprocesses);
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }
}
