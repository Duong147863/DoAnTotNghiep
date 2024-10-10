import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';

class WorkingprocessService{
  Future<http.Response> getWorkingProcessOf(int accountID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}workingprocess/$accountID'));
  }
}