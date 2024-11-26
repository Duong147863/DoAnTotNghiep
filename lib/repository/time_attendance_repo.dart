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

  Future<List<Timekeepings>> getCheckinHistoryOf(String profileID) async {
    final response = await service.getPersonalCheckinHistory(profileID);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((x) => Timekeepings.fromJson(x)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
