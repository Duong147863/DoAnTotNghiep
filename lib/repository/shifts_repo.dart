import 'dart:convert';

import 'package:nloffice_hrm/api_services/shifts_services.dart';
import 'package:nloffice_hrm/models/shifts_model.dart';

class ShiftsRepository {
  final ShiftsServices service = ShiftsServices();
  Future<bool> addShifts(Shifts shifts) async {
    final response = await service.addShifts(shifts);
    if (response.statusCode == 200) {
      print("add successful. Response body: ${response.body}");
      return true;
    } else {
      print("Failed to add profile: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to add profile: ${response.statusCode}');
    }
  }

  Future<List<Shifts>> getAllShifts() async {
    final response = await service.getAllShifts();
    if (response.statusCode == 200) {
      print("Load successful. Response body: ${response.body}");
      return List<Shifts>.from(
          json.decode(response.body).map((x) => Shifts.fromJson(x)));
    } else {
      print("Faild to load profile: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load data');
    }
  }
  Future<bool> updatedShifts(Shifts shifts) async {
    try {
      final response = await service.updateShifts(shifts);
      if (response.statusCode == 200) {
        print("Update successful. Response body: ${response.body}");
        return true;
      } else {
        print("Failed to update Shifts: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to update Shifts');
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to update Shifts');
    }
  }
  Future<bool> deleteShifts(String shiftId) async {
    try {
      final response = await service.deleteShifts(shiftId);
      if (response.statusCode == 200) {
        print("Delete successful. Response body: ${response.body}");
        return true;
      } else {
        print("Failed to delete Shifts: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to delete Shifts');
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to delete Shifts');
    }
  }
}
