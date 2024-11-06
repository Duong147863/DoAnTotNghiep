import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

  Future<void> addNewPosition(Positions position) async {
    try {
      await repository.addPosition(position);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create data: $e');
    }
  }

  Future<void> updatePosition(Positions positions) async {
    try {
      await repository.updatedPosition(positions);

      int index =
          _list.indexWhere((pos) => pos.positionId == positions.positionId);
      if (index != -1) {
        _list[index] = positions;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update department: $e');
    }
  }
  Future<void> deletePosition(String positionId) async {
    try {
      bool success = await repository.deletePosition(positionId);
      if (success) {
        _list.removeWhere((position) => position.positionId == positionId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete position');
      }
    } catch (e) {
      throw Exception('Failed to delete position: $e');
    }
  }
}
