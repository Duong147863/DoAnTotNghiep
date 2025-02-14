import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/diplomas_model.dart';

class DiplomaService {
  Future<http.Response> getDiplomaOf(String profileID) async {
    return await http.get(
        Uri.parse('${AppStrings.baseUrlApi}diploma/show/$profileID'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
        });
  }

  Future<http.Response> createNewDiploma(Diplomas diploma) async {
    return await http.post(
      Uri.parse('${AppStrings.baseUrlApi}diploma/create'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(diploma.toJson()),
    );
  }

   Future<http.Response>updateDiplomas(Diplomas diploma) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}diploma/update'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(diploma.toJson()),
    );
  }
  Future<http.Response> deleteDiplomas(String dilomaId) async {
    return await http.delete(
      Uri.parse('${AppStrings.baseUrlApi}diploma/delete/$dilomaId'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Accept': 'application/json',
      },
    );
  }
}
