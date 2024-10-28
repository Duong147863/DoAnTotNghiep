
import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';

class EnterpriseService {
  Future<http.Response> getEnterpriseInfo() async {
    return await http.get(Uri.parse('${AppStrings.baseUrlApi}enterprise'));
  }

  Future<http.Response> updateEnterpriseInfo() async {
    return await http
        .put(Uri.parse('${AppStrings.baseUrlApi}enterprise/update'));
  }
}
