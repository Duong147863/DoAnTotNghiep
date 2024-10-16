import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';
import 'package:nloffice_hrm/repository/relatives_repo.dart';

class RelativesViewModel extends ChangeNotifier {
  final RelativesRepository repository = RelativesRepository();

  List<Relatives> _list = [];
  bool fetchingData = false;
  List<Relatives> get listRelatives => _list;

  Future<void> fetchRelativesOf(int profileID) async {
    fetchingData = true;
    try {
      _list = await repository.fetchRelativesOf(profileID);
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
    fetchingData = false;
  }
}
