import 'package:nloffice_hrm/api_services/absents_services.dart';
import 'package:nloffice_hrm/models/absents_model.dart';

final AbsentsService service = AbsentsService();

class AbsentsRepository {
    Future<bool> addNewAbsent(Absents absents) async {
    final response = await service.createNewAbsent(absents);
    if (response.statusCode == 200) {
      print("add successful. Response body: ${response.body}");
      return true;
    } else {
      print("Failed to add profile: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to add profile: ${response.statusCode}');
    }
  }
}
