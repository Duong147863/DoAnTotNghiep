import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';

class RelativeService{
  Future<http.Response> getRelativesOf(int profileID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}relatives/$profileID'));
  }
}