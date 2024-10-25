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
}
