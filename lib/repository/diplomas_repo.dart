import 'dart:convert';

import 'package:nloffice_hrm/api_services/diploma_service.dart';
import 'package:nloffice_hrm/models/diplomas_model.dart';

class DiplomasRepository {
  final DiplomaService service = DiplomaService();

  Future<List<Diplomas>> fetchAllDiplomasOfEnterprises(int enterpriseID) async {
    final response = await service.getAllDiplomasOfEnterprises(enterpriseID);

    if (response.statusCode == 200) {
      return List<Diplomas>.from(
          json.decode(response.body).map((x) => Diplomas.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
