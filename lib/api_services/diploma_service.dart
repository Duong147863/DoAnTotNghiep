import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/diplomas_model.dart';

class DiplomaService {
  Future<http.Response> getAllDiplomasOfEnterprises(int enterprisesID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}diplomas/$enterprisesID'));
  }

  // Future<http.Response> createNewDiploma(Diplomas diploma) async {
  //   return await http.post(
  //     Uri.parse('${AppStrings.baseUrlApi}diploma/create'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //     },
  //     body: json.encode(diploma.toJson()),

  //   );
  // }
  Future<http.Response> createNewDiploma(Diplomas diploma) async {
    final response = await http.post(
      Uri.parse('${AppStrings.baseUrlApi}diploma/create'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(diploma.toJson()),
    );
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response;
  }

  Future<http.Response> updatExistedDiploma() async {
    return await http.put(Uri.parse(''));
  }
}
