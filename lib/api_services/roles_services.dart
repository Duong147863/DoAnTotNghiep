import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
class RolesServices {
   Future<http.Response> getAllRoles() async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}roles'), headers: {
      'Authorization': 'Bearer ${AppStrings.TOKEN}',
    });
  }
}