import 'dart:convert';

import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/models/decisions_model.dart';

class DecisionService {
  Future<http.Response> getAllDecisions() async {
    return await http.get(Uri.parse('${AppStrings.baseUrlApi}decisions'));
  }

  Future<http.Response> createNewDecision(Decisions decision) async {
    return await http.post(Uri.parse('${AppStrings.baseUrlApi}decision/create'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(decision.toJson()));
  }

  Future<http.Response> updateDecision() async {
    return await http
        .put(Uri.parse('${AppStrings.baseUrlApi}decisions/update'));
  }

  Future<http.Response> deleteDecision() async {
    return await http.delete(Uri.parse(''));
  }
}
