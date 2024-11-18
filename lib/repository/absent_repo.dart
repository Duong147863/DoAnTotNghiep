import 'dart:convert';

import 'package:nloffice_hrm/api_services/absents_services.dart';
import 'package:nloffice_hrm/models/absents_model.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';

final AbsentsService service = AbsentsService();

class AbsentsRepository {
  Future<bool> addNewAbsent(Absents absents) async {
    final response = await service.createNewAbsent(absents);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to add profile: ${response.statusCode}');
    }
  }

  Future<List<Absents>> fetchAllAbsents() async {
    final response = await service.getAllAbsents();

    if (response.statusCode == 200) {
      return List<Absents>.from(
        json.decode(response.body).map((x) => Absents.fromJson(x)),
      );
    } else {
      throw Exception('Failed to load absents: ${response.statusCode}');
    }
  }

  Future<List<Absents>> getPersonalAbsents(String profileID) async {
    final response = await service.getPersonalAbsents(profileID);

    if (response.statusCode == 200) {
      return List<Absents>.from(
        json.decode(response.body).map((x) => Absents.fromJson(x)),
      );
    } else {
      throw Exception('Failed to load absents: ${response.statusCode}');
    }
  }
  Future<bool> updateAbents(Absents asbents) async {
    try {
      final response = await service.updateAbents(asbents);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update Trainingprocesses');
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to update Trainingprocesses');
    }
  }
   Future<bool> deleteAbents(int ID) async {
    try {
      final response = await service.deleteAbents(ID);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false; 
      }
    } catch (error) {
      throw Exception('Failed to delete Relative');
    }
  }
}
