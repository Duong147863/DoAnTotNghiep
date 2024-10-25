import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/positions_model.dart';
import 'package:nloffice_hrm/repository/positions_repo.dart';

class PositionsViewModel extends ChangeNotifier {
  final PositionsRepository repository = PositionsRepository();

  List<Positions> _list = [];
  bool fetchingData = false;
  List<Positions> get listPositions => _list;

  Future<void> fetchPositions() async {
    fetchingData = true;
    try {
      _list = await repository.getAllPositions();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }
}
