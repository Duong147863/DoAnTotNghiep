import 'dart:convert';

import 'package:nloffice_hrm/api_services/salary_service.dart';
import 'package:nloffice_hrm/models/salaries_model.dart';

class SalariesRepository {
  final SalaryService service = SalaryService();

  Future<List<Salaries>> fetchAllSalariesByEnterpriseID(
      int enterpriseID) async {
    final response = await service.getAllSalariesByEnterpriseID(enterpriseID);

    if (response.statusCode == 200) {
      return List<Salaries>.from(
          json.decode(response.body).map((x) => Salaries.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
