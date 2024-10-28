import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/decisions_model.dart';
import 'package:nloffice_hrm/repository/decisions_repo.dart';

class DecisionsViewModel extends ChangeNotifier {
  final DecisionsRepository repository = DecisionsRepository();

  List<Decisions> _list = [];
  bool fetchingData = false;
  List<Decisions> get listDecisions => _list;

  Future<void> fetchAllDecisions(int enterpriseID) async {
    fetchingData = true;
    try {
      _list = await repository.fetchAllDecisions();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }
}
