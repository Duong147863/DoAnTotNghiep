import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/positions_model.dart';

class PositionService {
  Future<http.Response> getAllPositionsByEnterpriseID(int enterpriseID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}positions/$enterpriseID'));
  }

  Future<http.Response> createNewPosition() async {
    return await http.post(Uri.parse(''));
  }

  Future<http.Response> updateExistedPosition() async {
    return await http.put(Uri.parse(''));
  }
}
