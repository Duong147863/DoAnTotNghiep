import 'dart:convert';

import 'package:nloffice_hrm/api_services/time_attendance_service.dart';
import 'package:nloffice_hrm/models/timekeepings_model.dart';

class TimekeepingRepo {
  final TimeAttendanceService service = TimeAttendanceService();

  Future<bool> checkIn(Timekeepings checkinTime) async {
    final response = await service.checkIn(checkinTime);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
          'Failed to checkin: ${response.body} - ${response.statusCode}');
    }
  }

  Future<List<Timekeepings>> getCheckinHistoryOf(
      String from, String to, String profileID) async {
    final response =
        await service.getPersonalCheckinHistory(from, to, profileID);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((x) => Timekeepings.fromJson(x)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Timekeepings>> getAllAttendanceHistory(
      String from, String to) async {
    final response = await service.getAllCheckinHistory(from, to);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((x) => Timekeepings.fromJson(x)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> getLateEmployees(String from, String to) async {
    final response = await service.getLateEmployeesList(from, to);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((x) => Timekeepings.fromJson(x)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, int>> getWeeklyPersonalWorkHours(
      String from, String to, String profileID) async {
    final response =
        await service.getWeeklyPersonalWorkHours(from, to, profileID);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Trả về số lượng nhân viên đã nghỉ việc và đang làm việc
      return {
        'genderMan': data['genderMan'],
        'genderWoman': data['genderWoman'],
        'married': data['married'],
      };
    } else {
      throw Exception('Failed to load members count');
    }
  }
}
