import 'dart:convert';

import 'package:nloffice_hrm/api_services/enterprise_service.dart';
import 'package:nloffice_hrm/models/enterprises_model.dart';

class EnterprisesRepository {
  final EnterpriseService service = EnterpriseService();

  Future<Enterprises> fetchAllEnterprises() async {
    final response = await service.getEnterprise();
    if (response.statusCode == 200) {
      return json.decode(response.body).map((x) => Enterprises.fromJson(x));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
