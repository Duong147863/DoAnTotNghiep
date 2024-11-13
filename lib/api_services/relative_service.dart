import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';

class RelativeService {
  Future<http.Response> getAllRelative(String profileId) async {
    return await http.get(
        Uri.parse('${AppStrings.baseUrlApi}profile/relatives/$profileId'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
        });
  }

  Future<http.Response> createNewRelative(Relatives relative) async {
    return await http.post(
        Uri.parse('${AppStrings.baseUrlApi}relatives/create'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(relative.toJson()));
  }
  Future<http.Response> updateRelative(Relatives relatives) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}relatives/update'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(relatives.toJson()),
    );
  }
  Future<http.Response> deleteRelative(int relativesId) async {
    return await http.delete(
      Uri.parse('${AppStrings.baseUrlApi}relatives/delete/$relativesId'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Accept': 'application/json',
      },
    );
  }

}
