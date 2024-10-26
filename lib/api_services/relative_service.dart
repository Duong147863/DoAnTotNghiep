import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';

class RelativeService {
  Future<http.Response> getRelativesOf(int profileID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}relatives/$profileID'));
  }

  Future<http.Response> createNewRelative(Relatives Relative) async {
    return await http.post(Uri.parse('${AppStrings.baseUrlApi}relative'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode(Relative.toJson()));
  }
}
