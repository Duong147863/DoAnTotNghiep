import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';

class SalaryService{
  Future<http.Response> getAllSalariesByEnterpriseID(int enterpriseID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}salaries/$enterpriseID'));
  }
}