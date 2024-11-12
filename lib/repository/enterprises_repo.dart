import 'dart:convert';

import 'package:nloffice_hrm/api_services/enterprise_service.dart';
import 'package:nloffice_hrm/models/enterprises_model.dart';

class EnterprisesRepository {
  final EnterpriseService service = EnterpriseService();

    Future<List<Enterprises>> fetchAllEnterprises() async {
    final response = await service.getAllEnterprise();

    if (response.statusCode == 200) {
        print("Load successful. Response body: ${response.body}");
      return List<Enterprises>.from(
          json.decode(response.body).map((x) => Enterprises.fromJson(x)));
    } else {
        print("Load to Fail Enter: ${response.statusCode}");
        print("Response body: ${response.body}");
      throw Exception('Failed to load data');
    }
  }

}
