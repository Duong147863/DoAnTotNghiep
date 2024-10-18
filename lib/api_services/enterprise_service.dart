import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/enterprises_model.dart';

class EnterpriseService {
  Future<http.Response> getAllEnterprises() async {
    return await http.get(Uri.parse('${AppStrings.baseUrlApi}enterprises'));
  }
}
