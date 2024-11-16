import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/insurance_model.dart';
class InsuranceServices {
   Future<http.Response> getInsurancesOf(String profileID) async {
    return await http.get(
        Uri.parse('${AppStrings.baseUrlApi}insurances/show/$profileID'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
        });
  }

  Future<http.Response> createNewInsurances(Insurance insurances) async {
    return await http.post(
      Uri.parse('${AppStrings.baseUrlApi}insurances/create'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(insurances.toJson()),
    );
  }

   Future<http.Response>updateInsurances(Insurance insurances) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}insurances/update'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(insurances.toJson()),
    );
  }
  Future<http.Response> deleteInsurances(String insurancesId) async {
    return await http.delete(
      Uri.parse('${AppStrings.baseUrlApi}insurances/delete/$insurancesId'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Accept': 'application/json',
      },
    );
  }
}