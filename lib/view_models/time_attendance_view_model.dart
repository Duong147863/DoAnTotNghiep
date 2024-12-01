import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/timekeepings_model.dart';
import 'package:nloffice_hrm/repository/time_attendance_repo.dart';

import '../models/working_hours.dart';

class TimeKeepingViewModel extends ChangeNotifier {
  final TimekeepingRepo repository = TimekeepingRepo();

  List<Timekeepings> _listAll = [];
  List<Timekeepings> _list1 = [];
  List<Timekeepings> _listLate = [];
  List<Timekeepings> _listOT = [];
  bool fetchingData = false;
  bool fetchingWorkHoursStats = false;
  List<Timekeepings> get listAll => _listAll;
  List<Timekeepings> get list1 => _list1;
  List<Timekeepings> get listLate => _listLate;
  List<Timekeepings> get listOT => _listOT;

  Future<void> checkin(Timekeepings trainingprocesses) async {
    try {
      await repository.checkIn(trainingprocesses);
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }

  Future<void> getProfileCheckInHistory(
      String from, String to, String profileID) async {
    fetchingData = true;
    try {
      _list1 = await repository.getCheckinHistoryOf(from, to, profileID);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load info: $e');
    }
    fetchingData = false;
  }

  Future<void> getAllCheckInHistory(String from, String to) async {
    fetchingData = true;
    try {
      _listAll = await repository.getAllAttendanceHistory(from, to);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load info: $e');
    }
    fetchingData = false;
  }

  Future<void> getLateEmployees(String from, String to) async {
    fetchingData = true;
    try {
      _listLate = await repository.getLateEmployees(from, to);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load info: $e');
    }
    fetchingData = false;
  }

  List<WorkHours> _workHours = [];
  Map<String, int> _weekData = {};

  Map<String, int> get weekData => _weekData;

  Future<void> fetchWorkHours(String from, String to, String profileID) async {
    try {
      _workHours =
          await repository.getWeeklyPersonalWorkHours(from, to, profileID);
      // Tạo danh sách ngày trong tuần với giá trị mặc định 0
      List<String> daysOfWeek = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
      _weekData = {
        for (var day in daysOfWeek) day: 0,
      };
      // Cập nhật giá trị nếu có dữ liệu
      for (var workHour in _workHours) {
        _weekData[workHour.dayOfWeek] = workHour.hoursWorked;
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching work hours: $e');
    }
  }
}
