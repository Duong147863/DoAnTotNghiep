import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/hirings_model.dart';
import 'package:nloffice_hrm/repository/hirings_repo.dart';

class HiringsViewModel extends ChangeNotifier {
  final HiringsRepository repository = HiringsRepository();
  bool fetchingData = false;
  List<Hirings> _list = [];
  List<Hirings> get listHirigns => _list;

  Future<void> createNewHirings(Hirings hirings) async {
    try {
      await repository.createNewHirings(hirings);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add absent: $e');
    }
  }

  Future<void> getAllHirings() async {
    fetchingData = true;
    try {
      _list = await repository.getAllHirings();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }

    Future<void> updateHirings(Hirings hirings) async {
    try {
      await repository.updateHirings(hirings);

      int index =
          _list.indexWhere((hir) => hir.hiringProfileId == hirings.hiringProfileId);
      if (index != -1) {
        _list[index] = hirings;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update relatives: $e');
    }
  }
}
