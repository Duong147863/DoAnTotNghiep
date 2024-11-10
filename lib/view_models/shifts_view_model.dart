
import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/shifts_model.dart';
import 'package:nloffice_hrm/repository/shifts_repo.dart';

class ShiftsViewModel extends ChangeNotifier {
  final ShiftsRepository repository = ShiftsRepository();
  List<Shifts> _list = [];
  bool fetchingData = false;
  List<Shifts> get listShifts => _list;

  Future<void> addShifts(Shifts shifts) async {
    try {
      await repository.addShifts(shifts);
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }
  Future<void> getAllShifts() async {
    fetchingData = true;
    notifyListeners();
    try {
      _list = await repository.getAllShifts();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }
  Future<void> updateShifts(Shifts shifts) async {
    try {
      await repository.updatedShifts(shifts);

      int index =
          _list.indexWhere((shi) => shi.shiftId == shifts.shiftId);
      if (index != -1) {
        _list[index] = shifts;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update shifts: $e');
    }
  }

  Future<void> deleteShifts(String shiftId) async {
    try {
      bool success = await repository.deleteShifts(shiftId);
      if (success) {
        _list.removeWhere((shi) => shi.shiftId == shiftId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete shifts');
      }
    } catch (e) {
      throw Exception('Failed to delete shifts: $e');
    }
  }
}
