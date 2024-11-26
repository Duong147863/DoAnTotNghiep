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

  Future<http.Response> getPersonalCheckinHistory(String profileID) async {
    return await http.get(
      Uri.parse("${AppStrings.baseUrlApi}all/$profileID"),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    );
  }
}
