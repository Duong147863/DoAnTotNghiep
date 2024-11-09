import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/positions_model.dart';

class PositionService {
  Future<http.Response> getAllPositions() async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}positions'), headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
    });
  }

  Future<http.Response> createNewPosition(Positions position) async {
    return await http.post(Uri.parse('${AppStrings.baseUrlApi}position/create'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(position.toJson()));
  }

  Future<http.Response> updatePosition(Positions position) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}position/update'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(position.toJson()),
    );
  }

  Future<http.Response> deletePosition(String positionId) async {
    return await http.delete(
      Uri.parse('${AppStrings.baseUrlApi}position/delete/$positionId'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Accept': 'application/json',
      },
    );
  }
}
