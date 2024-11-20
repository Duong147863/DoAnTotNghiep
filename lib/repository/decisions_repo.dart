import 'dart:convert';

import 'package:nloffice_hrm/api_services/decision_service.dart';
import 'package:nloffice_hrm/models/decisions_model.dart';

class DecisionsRepository {
  final DecisionService service = DecisionService();

  Future<List<Decisions>> getAllDecision() async {
    final response = await service.getAllDecision();
    if (response.statusCode == 200) {
      return List<Decisions>.from(
        json.decode(response.body).map((x) => Decisions.fromJson(x)),
      );
    } else {
      throw Exception('Failed to load absents: ${response.statusCode}');
    }
  }

  Future<bool> createNewDecisions(Decisions decisions) async {
    try {
      final response = await service.createNewDecisions(decisions);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add department');
      }
    } catch (error) {
      throw Exception('Failed to add department ${error}');
    }
  }

  Future<bool> updateDecisions(Decisions decisions) async {
    try {
      final response = await service.updateDecisions(decisions);
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update department');
      }
    } catch (error) {
      throw Exception('Failed to update department');
    }
  }

  Future<bool> deleteDecisions(String decisionId) async {
    try {
      final response = await service.deleteDecisions(decisionId);
      if (response.statusCode == 200) {
        print("Response body: ${response.body}");
        return true;
      } else {
        print("Failed to load data: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to delete department');
      }
    } catch (error) {
      throw Exception('Failed to delete department');
    }
  }
}
