import 'dart:convert';

import 'package:nloffice_hrm/api_services/labor_contact_services.dart';
import 'package:nloffice_hrm/models/labor_contracts_model.dart';

class LaborContactRepository {
  final LaborContactServices service = LaborContactServices();
  Future<bool> addLaborContact(LaborContracts laborContact) async {
    final response = await service.addNewLaborContact(laborContact); //
    if (response.statusCode == 200) {
      print("add successful. Response body: ${response.body}");
      return true;
    } else {
      print("Failed to add laborcontact: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to add laborcontact: ${response.statusCode}');
    }
  }
  Future<List<LaborContracts>> getLaborContactOf(
      String laborContactId) async {
    final response = await service.getLaborContactOf(laborContactId);
    if (response.statusCode == 200) {
      print("Load successful. Response body: ${response.body}");

      final List<dynamic> jsonData = json.decode(response.body);

      return jsonData.map((x) => LaborContracts.fromJson(x)).toList();
    } else {
      print("Failed to load LaborContracts: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load data');
    }
  }
}
