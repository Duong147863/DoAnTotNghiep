import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/decisions_model.dart';
import 'package:http/http.dart' as http;

class DecisionService {
  Future<http.Response>getAllDecisionsByEnterpriseID(int enterpriseID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}decisions/$enterpriseID'));
  }
}
