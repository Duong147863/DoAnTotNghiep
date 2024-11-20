import 'dart:convert';

import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/models/decisions_model.dart';

class DecisionService {
 Future<http.Response> getAllDecision() async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}decisions/abc'),
       headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
    });
  }

  Future<http.Response> createNewDecisions(Decisions decisions) async {
    return await http.post(Uri.parse('${AppStrings.baseUrlApi}decision/create'),
        headers: {
          'Authorization': 'Bearer ${AppStrings.TOKEN}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(decisions.toJson()));
  }

  Future<http.Response>updateDecisions(Decisions decisions) async {
    return await http.put(
      Uri.parse('${AppStrings.baseUrlApi}decision/update'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(decisions.toJson()),
    );
  }
    Future<http.Response> deleteDecisions(String decisionId) async {
    return await http.delete(
      Uri.parse('${AppStrings.baseUrlApi}decision/delete/$decisionId'),
      headers: {
        'Authorization': 'Bearer ${AppStrings.TOKEN}',
        'Accept': 'application/json',
      },
    );
  }
}
