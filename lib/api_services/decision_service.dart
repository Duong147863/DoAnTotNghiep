import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:http/http.dart' as http;

class DecisionService {
  Future<http.Response> getAllDecisionsByEnterpriseID(int enterpriseID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}decisions/$enterpriseID'));
  }

  Future<http.Response> createNewDecision() async {
    return await http.post(Uri.parse(''));
  }

  Future<http.Response> updateDecision() async {
    return await http.put(Uri.parse(''));
  }

  Future<http.Response> deleteDecision() async {
    return await http.delete(Uri.parse(''));
  }
}
