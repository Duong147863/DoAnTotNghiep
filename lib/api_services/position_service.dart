import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/positions_model.dart';

class PositionService {
  Future<http.Response> getAllPositions() async {
    return await http.get(Uri.parse('${AppStrings.baseUrlApi}positions'));
  }

  Future<http.Response> createNewPosition(Positions position) async {
    return await http.post(Uri.parse('${AppStrings.baseUrlApi}position/create'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(position.toJson()));
  }

  Future<http.Response> updateExistedPosition() async {
    return await http.put(Uri.parse(''));
  }
}
