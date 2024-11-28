import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/labor_contracts_model.dart';
class LaborContactServices {
   Future<http.Response> addNewLaborContact(LaborContracts laborContact) async {
    return await http.post(
      Uri.parse('${AppStrings.baseUrlApi}contract/create'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(laborContact.toJson()),
    );
  }
   Future<http.Response> getLaborContactOf(String profileId) async {
    return await http.get(
        Uri.parse('${AppStrings.baseUrlApi}contract/ContactsOfProfile/$profileId'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
        });
  }
  Future<http.Response>updateLaborContact(LaborContracts laborContact) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}contract/update'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(laborContact.toJson()),
    );
  }
}