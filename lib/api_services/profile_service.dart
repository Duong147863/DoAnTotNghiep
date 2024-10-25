import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/profiles_model.dart';

class ProfileService{
  Future<http.Response> getAllProfilesByEnterpriseID(int enterpriseID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}profiles/$enterpriseID'));
  }
  Future<http.Response> getAllProfile() async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}profiles'));
  }
  Future<http.Response> addNewProfile(Profiles profile) async {
  final url = Uri.parse('${AppStrings.baseUrlApi}profiles');
  return await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(profile.toJson()),
  );
}

}
