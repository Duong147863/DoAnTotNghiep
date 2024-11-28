import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/trainingprocesses_model.dart';
import 'package:nloffice_hrm/repository/trainingprocesses_repo.dart';

class TrainingprocessesViewModel extends ChangeNotifier {
  final TrainingprocessesRepository repository = TrainingprocessesRepository();

  List<Trainingprocesses> _list = [];
  bool fetchingData = false;
   List<Trainingprocesses> get listTrainingprocesses => _list;

  Future<void> getTrainingProcessesOf(String profileID) async {
    try {
      List<Trainingprocesses> trainingprocessesList =
          await repository.getTrainingProcessesOf(profileID);
      _list = trainingprocessesList
          .where((trainingProcess) => trainingProcess.profileId == profileID)
          .toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load training processes: $e');
    }
  }
    Future<bool> createTrainingProcesses(Trainingprocesses trainingprocesses, Function(String) callback) async {
    try {
      await repository.createTrainingProcesses(trainingprocesses,callback); // Call the repository method
      return true;
    } catch (e) {
      callback('Failed to add relative: $e');  // Call the callback with error message
      return false;
    }
  }

   Future<void> updateTrainingProcesses(Trainingprocesses trainingprocesses, Function(String) callback) async {
    try {
      await repository.updateTrainingProcesses(trainingprocesses,callback);
      int index =
          _list.indexWhere((training) => training.trainingprocessesId == trainingprocesses.trainingprocessesId);
      if (index != -1) {
        _list[index] = trainingprocesses;
        notifyListeners();
      }
    } catch (e) {
      callback('Failed to add relative: $e');  // Call the callback with error message
    }
  }

  Future<void> deleteTrainingProcesses(int trainingprocessesId) async {
    try {
      bool success = await repository.deleteTrainingProcesses(trainingprocessesId);
      if (success) {
        _list.removeWhere((tra) => tra.trainingprocessesId == trainingprocessesId);
        notifyListeners();
      } else {
        throw Exception('Failed to delete Trainingprocesses');
      }
    } catch (e) {
      throw Exception('Failed to delete Trainingprocesses: $e');
    }
  }
}