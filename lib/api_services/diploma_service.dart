import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:nloffice_hrm/models/diplomas_model.dart';

class DiplomaService{
   Future<http.Response> getAllDiplomasOfEnterprises(int enterprisesID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}diplomas/$enterprisesID'));
  }
}