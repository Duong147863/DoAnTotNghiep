import 'dart:convert';

import 'package:nloffice_hrm/api_services/shifts_services.dart';
import 'package:nloffice_hrm/models/shifts_model.dart';

class ShiftsRepository {
  final ShiftsServices service = ShiftsServices();
  Future<bool> addShifts(Shifts shifts) async {
    final response = await service.addShifts(shifts);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to add profile: ${response.statusCode}');
    }
  }

  Future<List<Shifts>> getAllShifts() async {
    final response = await service.getAllShifts();
    if (response.statusCode == 200) {
      return List<Shifts>.from(
          json.decode(response.body).map((x) => Shifts.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> updatedShifts(Shifts shifts) async {
    try {
      final response = await service.updateShifts(shifts);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update Shifts');
      }
    } catch (error) {
      throw Exception('Failed to update Shifts');
    }
  }

  Future<bool> deleteShifts(String shiftId) async {
    try {
      final response = await service.deleteShifts(shiftId);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete Shifts');
      }
    } catch (error) {
      throw Exception('Failed to delete Shifts');
    }
  }
}
