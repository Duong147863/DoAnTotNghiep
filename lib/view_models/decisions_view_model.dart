import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/decisions_model.dart';
import 'package:nloffice_hrm/repository/decisions_repo.dart';

class DecisionsViewModel extends ChangeNotifier {
  final DecisionsRepository repository = DecisionsRepository();

  List<Decisions> _list = [];
  bool fetchingData = false;
  List<Decisions> get listDecisions => _list;

  Future<void> getAllDecisions() async {
    fetchingData = true;
    try {
      _list = await repository.getAllDecision();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }
   Future<void> createNewDecisions(Decisions decisions) async {
    try {
      await repository.createNewDecisions(decisions);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add absent: $e');
    }
  }
    Future<void> updateDecisions(Decisions decisions) async {
    try {
      await repository.updateDecisions(decisions);

      int index =
          _list.indexWhere((dec) => dec.decisionId == decisions.decisionId);
      if (index != -1) {
        _list[index] = decisions;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update relatives: $e');
    }
  }
  Future<void> deleteDecisions(String decisionId) async {
    try {
      bool success = await repository.deleteDecisions(decisionId);
      if (success) {
        _list.removeWhere((dec) => dec.decisionId == decisionId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete relatives');
      }
    } catch (e) {
      throw Exception('Failed to delete relatives: $e');
    }
  }
}
