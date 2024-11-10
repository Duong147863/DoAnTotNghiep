import 'dart:convert';

import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/models/shifts_model.dart';

class ShiftsServices {
   Future<http.Response> addShifts(Shifts shifts) async {
    return await http.post(Uri.parse('${AppStrings.baseUrlApi}shift/create'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(shifts.toJson()));
  }
   Future<http.Response> getAllShifts() async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}shifts'), headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
    });
  }
  Future<http.Response> updateShifts(Shifts shifts) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}shift/update'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(shifts.toJson()),
    );
  }
  Future<http.Response> deleteShifts(String shiftsId) async {
    return await http.delete(
      Uri.parse('${AppStrings.baseUrlApi}shift/delete/$shiftsId'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Accept': 'application/json',
      },
    );
  }
}