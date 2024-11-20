import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/hirings_model.dart';
class HiringsModel {
  Future<http.Response> createNewHirings(Hirings hirings) async {
    return await http.post(Uri.parse('${AppStrings.baseUrlApi}hiring/create'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(hirings.toJson()));
  }

  Future<http.Response> getAllHirings() async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}hirings'), headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
    });
  }

   Future<http.Response>updateHirings(Hirings hirings) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}hiring/update'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(hirings.toJson()),
    );
  }
}