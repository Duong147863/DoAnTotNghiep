import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';

class ProjectService{
  Future<http.Response> getProjectsByEnterpriseID(int enterpriseID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}projects/$enterpriseID'));
  }
}