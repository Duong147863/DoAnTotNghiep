import 'dart:convert';

import 'package:nloffice_hrm/api_services/account_service.dart';
import 'package:nloffice_hrm/models/accounts_model.dart';

class AccountsRepository {
  final AccountService service = AccountService();

  Future<List<Accounts>> fetchAllAdminAccounts() async {
    final response = await service.getAllAdminAccounts();

    if (response.statusCode == 200) {
      return List<Accounts>.from(
          json.decode(response.body).map((x) => Accounts.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Accounts>> fetchAllAccountsOfEnterprise(int enterpriseID) async {
    final response = await service.getAllAccountsByEnterprise(enterpriseID);

    if (response.statusCode == 200) {
      return List<Accounts>.from(
          json.decode(response.body).map((x) => Accounts.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
