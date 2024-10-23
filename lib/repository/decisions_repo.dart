import 'dart:convert';

import 'package:nloffice_hrm/api_services/decision_service.dart';
import 'package:nloffice_hrm/models/decisions_model.dart';

class DecisionsRepository {
  final DecisionService service = DecisionService();

  Future<List<Decisions>> fetchAllDecisionsByEnterpriseID(int enterpriseID) async {
    final response = await service.getAllDecisionsByEnterpriseID(enterpriseID);

    if (response.statusCode == 200) {
      return List<Decisions>.from(
          json.decode(response.body).map((x) => Decisions.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
