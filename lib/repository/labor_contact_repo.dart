import 'dart:convert';

import 'package:nloffice_hrm/api_services/labor_contact_services.dart';
import 'package:nloffice_hrm/models/labor_contracts_model.dart';

class LaborContactRepository {
  final LaborContactServices service = LaborContactServices();
  Future<bool> addLaborContact(LaborContracts laborContact) async {
    final response = await service.addNewLaborContact(laborContact); //
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to add laborcontact: ${response.statusCode}');
    }
  }
  Future<List<LaborContracts>> getLaborContactOf(
      String laborContactId) async {
    final response = await service.getLaborContactOf(laborContactId);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map((x) => LaborContracts.fromJson(x)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future<bool> updateLaborContact(LaborContracts laborContact) async {
    try {
      final response = await service.updateLaborContact(laborContact);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update Trainingprocesses');
      }
    } catch (error) {
      throw Exception('Failed to update Trainingprocesses');
    }
  }

  Future<bool> deleteLaborContact(String laborContractId) async {
    try {
      final response = await service.deleteLaborContact(laborContractId   );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete Trainingprocesses');
      }
    } catch (error) {
      throw Exception('Failed to delete Trainingprocesses');
    }
  }
}
