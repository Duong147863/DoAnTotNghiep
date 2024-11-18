import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/absents_model.dart';

class AbsentsService {
  Future<http.Response> createNewAbsent(Absents asbents) async {
    return await http.post(Uri.parse('${AppStrings.baseUrlApi}absent/create'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(asbents.toJson()));
  }

  Future<http.Response> getAllAbsents() async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}absents'), headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
    });
  }

  Future<http.Response> getPersonalAbsents(String profileId) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}absents/$profileId'), headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
    });
  }
   Future<http.Response>updateAbents(Absents asbents) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}absent/update'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(asbents.toJson()),
    );
  }
    Future<http.Response> deleteAbents(int ID) async {
    return await http.delete(
      Uri.parse('${AppStrings.baseUrlApi}absent/delete/$ID'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Accept': 'application/json',
      },
    );
  }
}
