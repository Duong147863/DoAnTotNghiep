import 'dart:convert';

import 'package:nloffice_hrm/api_services/enterprise_service.dart';
import 'package:nloffice_hrm/models/enterprises_model.dart';

class EnterprisesRepository {
  final EnterpriseService service = EnterpriseService();

  Future<Enterprises> fetchAllEnterprises() async {
    final response = await service.getEnterprise();
    if (response.statusCode == 200) {
      return Enterprises.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
