import 'dart:convert';

import 'package:nloffice_hrm/api_services/relative_service.dart';
import 'package:nloffice_hrm/models/relatives_model.dart';

class RelativesRepository {
  final RelativeService service = RelativeService();

  Future<List<Relatives>> fetchRelativesOf(int profileID) async {
    final response = await service.getRelativesOf(profileID);

    if (response.statusCode == 200) {
      return List<Relatives>.from(
          json.decode(response.body).map((x) => Relatives.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }
  
 Future<bool> addRelative(Relatives relatives) async {
    final response = await service.createNewRelative(relatives);
    if (response.statusCode == 200) {
      print("add successful. Response body: ${response.body}");
      return true;
    } else {
      print("Response body: ${response.body}");
      throw Exception('Failed to add profile: ${response.statusCode}');
    }
  }
}
