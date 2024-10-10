import 'package:nloffice_hrm/constant/app_strings.dart';
import 'package:http/http.dart' as http;
import 'package:nloffice_hrm/models/accounts_model.dart';

class AccountService {
  Future<http.Response> getAllAdminAccounts() async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}superadmin/accounts'));
  }

  Future<http.Response> getAllAccountsByEnterprise(int enterpriseID) async {
    return await http
        .get(Uri.parse('${AppStrings.baseUrlApi}admin/accounts/$enterpriseID'));
  }
}
