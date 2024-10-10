import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/accounts_model.dart';
import 'package:nloffice_hrm/repository/accounts_repo.dart';

class AccountsViewModel extends ChangeNotifier {
  final AccountsRepository repository = AccountsRepository();

  List<Accounts> _list = [];
  bool fetchingData = false;
  List<Accounts> get listAccounts => _list;

  Future<void> fetchAllAdminAccounts() async {
    fetchingData = true;
    try {
      _list = await repository.fetchAllAdminAccounts();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load datas: $e');
    }
    fetchingData = false;
  }

  Future<void> fetchAllAccountsOfEnterprise(int enterpriseID) async {
    fetchingData = true;
    try {
      _list = await repository.fetchAllAccountsOfEnterprise(enterpriseID);
      notifyListeners();
    } catch (e) {
      throw Exception('Fail to load data: $e');
    }
    fetchingData = false;
  }
}
