import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';
import 'package:nloffice_hrm/repository/relatives_repo.dart';

class RelativesViewModel extends ChangeNotifier {
  final RelativesRepository repository = RelativesRepository();

  List<Relatives> _list = [];
  bool fetchingData = false;
  List<Relatives> get listRelatives => _list;
  String? errorMessage;
  Future<void> fetchAllRelatives(String profileId) async {
    fetchingData = true;
    notifyListeners();
    try {
      _list = await repository.fetchAllRelatives(profileId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }

  Future<void> addRelative(Relatives relatives) async {
    try {
      await repository.addRelative(relatives);
    } catch (e) {
      throw Exception('Failed to add datas: $e');
    }
  }

  Future<void> updateRelatives(Relatives relatives) async {
    try {
      await repository.updatedRelatives(relatives);

      int index =
          _list.indexWhere((relav) => relav.profileId == relatives.profileId);
      if (index != -1) {
        _list[index] = relatives;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update relatives: $e');
    }
  }
    Future<void> deleteRelative(int relativesId) async {
    try {
      bool success = await repository.deleteRelative(relativesId);
      if (success) {
        _list.removeWhere((rela) => rela.relativeId == relativesId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete relatives');
      }
    } catch (e) {
      throw Exception('Failed to delete relatives: $e');
    }
  }
}
