import 'dart:convert';

import 'package:nloffice_hrm/api_services/enterprise_service.dart';
import 'package:nloffice_hrm/models/enterprises_model.dart';

class EnterprisesRepository {
  final EnterpriseService service = EnterpriseService();

  Future<Enterprises> fetchAllEnterprises() async {
    final response = await service.getEnterprise();
    if (response.statusCode == 200) {
           print("Update successful. Response body: ${response.body}");
      return Enterprises.fromJson(json.decode(response.body));
    } else {
        print("Failed to update profile: ${response.statusCode}");
        print("Response body: ${response.body}");
      throw Exception('Failed to load data');
    }
  }
}
