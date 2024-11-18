import 'dart:convert';

import 'package:nloffice_hrm/api_services/position_service.dart';
import 'package:nloffice_hrm/models/positions_model.dart';

class PositionsRepository {
  final PositionService service = PositionService();

  Future<List<Positions>> getAllPositions() async {
    final response = await service.getAllPositions();

    if (response.statusCode == 200) {
      return List<Positions>.from(
          json.decode(response.body).map((x) => Positions.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> addPosition(Positions position) async {
    final response = await service.createNewPosition(position);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to add position: ${response.statusCode}');
    }
  }

  Future<bool> updatedPosition(Positions postions) async {
    try {
      final response = await service.updatePosition(postions);
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to update department: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to update department');
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to update profile');
    }
  }

  Future<bool> deletePosition(String positionId) async {
    try {
      final response = await service.deletePosition(positionId);
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete position: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception('Failed to delete position');
      }
    } catch (error) {
      print("An error occurred: $error");
      throw Exception('Failed to delete position');
    }
  }
}
