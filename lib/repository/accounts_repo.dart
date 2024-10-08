import 'dart:convert';

import 'package:nloffice_hrm/api_services/account_service.dart';
import 'package:nloffice_hrm/models/accounts_model.dart';

class AccountsRepository {
  final AccountService _service = AccountService();

  Future<List<Accounts>> getAllAdminAccounts() async {
    final response = await _service.fetchAllAdminAccounts();

    if (response.statusCode == 200) {
      return List<Accounts>.from(
          json.decode(response.body).map((x) => Accounts.fromJson(x)));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
