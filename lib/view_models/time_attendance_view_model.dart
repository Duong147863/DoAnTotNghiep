import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/timekeepings_model.dart';
import 'package:nloffice_hrm/repository/time_attendance_repo.dart';

class TimeKeepingViewModel extends ChangeNotifier {
  final TimekeepingRepo repository = TimekeepingRepo();

  List<Timekeepings> _listAll = [];
  List<Timekeepings> _list1 = [];
  bool fetchingData = false;
  List<Timekeepings> get listAll => _listAll;
  List<Timekeepings> get list1 => _list1;

  Future<void> checkin(Timekeepings trainingprocesses) async {
    try {
      await repository.checkIn(trainingprocesses);
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }

  Future<void> getProfileCheckInHistory(String profileID) async {
    fetchingData = true;
    try {
      _list1 = await repository.getCheckinHistoryOf(profileID);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load profile info: $e');
    }
    fetchingData = false;
  }
}
