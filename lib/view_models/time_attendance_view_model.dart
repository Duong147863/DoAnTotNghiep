import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/timekeepings_model.dart';
import 'package:nloffice_hrm/repository/time_attendance_repo.dart';

class TimeKeepingViewModel extends ChangeNotifier {
  final TimekeepingRepo repository = TimekeepingRepo();

  List<Timekeepings> _listAll = [];
  List<Timekeepings> _list1 = [];
  List<Timekeepings> _listLate = [];
  bool fetchingData = false;
  bool fetchingWorkHoursStats = false;
  List<Timekeepings> get listAll => _listAll;
  List<Timekeepings> get list1 => _list1;
  List<Timekeepings> get listLate => _listLate;

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
      // _listLate = await repository.getLateEmployees(from, to);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load profile info: $e');
    }
    fetchingData = false;
  }

  Future<void> getMembersCountGenderAndMaritalStatus(String from, String to, String profileID) async {
    fetchingWorkHoursStats = true;
    notifyListeners();
    try {
      // List<WorkHours> counts = await repository.getMembersCountGenderAndMaritalStatus();
      // genderMan = counts['genderMan']??0;
      // genderWoman = counts['genderWoman']??0;
      // married = counts['married']??0;
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to fetch members count: $e');
    } finally {
      fetchingWorkHoursStats = false;
      notifyListeners();
    }
  }
}

class WorkHours {
  final String dayOfWeek;
  final DateTime date;
  final int hoursWorked;

  WorkHours({
    required this.dayOfWeek,
    required this.date,
    required this.hoursWorked,
  });

  factory WorkHours.fromJson(Map<String, dynamic> json) {
    return WorkHours(
      dayOfWeek: json['day_of_week'],
      date: DateTime.parse(json['date']),
      hoursWorked: json['hours_worked'],
    );
  }
}

List<WorkHours> fillMissingDays(List<WorkHours> data) {
  // Khởi tạo danh sách 7 ngày với số giờ mặc định là 0
  final List<WorkHours> fullWeek = [
    WorkHours(dayOfWeek: "Monday", date: DateTime.now(), hoursWorked: 0),
    WorkHours(dayOfWeek: "Tuesday", date: DateTime.now(), hoursWorked: 0),
    WorkHours(dayOfWeek: "Wednesday", date: DateTime.now(), hoursWorked: 0),
    WorkHours(dayOfWeek: "Thursday", date: DateTime.now(), hoursWorked: 0),
    WorkHours(dayOfWeek: "Friday", date: DateTime.now(), hoursWorked: 0),
    WorkHours(dayOfWeek: "Saturday", date: DateTime.now(), hoursWorked: 0),
    WorkHours(dayOfWeek: "Sunday", date: DateTime.now(), hoursWorked: 0),
  ];

  // Gán số giờ làm việc cho ngày tương ứng
  for (var item in data) {
    switch (item.dayOfWeek) {
      case "Monday":
        
        break;
      case "Tuesday":
        
        break;
      case "Wednesday":
        
        break;
      case "Thursday":
        
        break;
      case "Friday":
        
        break;
      case "Saturday":
        
        break;
      case "Sunday":
        
        break;
    }
  }

  return fullWeek;
}
