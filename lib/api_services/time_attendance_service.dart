import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/timekeepings_model.dart';

class TimeAttendanceService {
  Future<http.Response> checkIn(Timekeepings checkinTime) async {
    return await http.post(Uri.parse("${AppStrings.baseUrlApi}checkin"),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(checkinTime.toJson()));
  }
  
  Future<http.Response> getAllCheckinHistory(String from, String to) async {
    return await http.get(
      Uri.parse("${AppStrings.baseUrlApi}checkin/all?from=$from&to=$to"),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );
  }

  Future<http.Response> getLateEmployeesList(String from, String to) async {
    return await http.get(
      Uri.parse("${AppStrings.baseUrlApi}late-employees?from=$from&to=$to"),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );
  }

  Future<http.Response> getPersonalCheckinHistory(
      String from, String to, String profileID) async {
    return await http.get(
      Uri.parse(
          "${AppStrings.baseUrlApi}checkin/profile?from=$from&to=$to&profile_id=$profileID"),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );
  }

  Future<http.Response> getWeeklyPersonalWorkHours(
      String from, String to, String profileID) async {
    return await http.get(
      Uri.parse(
          "${AppStrings.baseUrlApi}hours/weekly/profile/$profileID?from=$from&to=$to"),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );
  }
}
