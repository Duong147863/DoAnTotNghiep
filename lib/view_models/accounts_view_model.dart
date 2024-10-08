import 'package:flutter/material.dart';
import 'package:nloffice_hrm/models/accounts_model.dart';
import 'package:nloffice_hrm/repository/accounts_repo.dart';

class AccountsViewModel extends ChangeNotifier {
  final AccountsRepository _repository = AccountsRepository();

  List<Accounts> _list = [];
  bool fetchingData = false;
  List<Accounts> get listAccounts => _list;

  Future<void> fetchAdminAccounts() async {
    fetchingData = true;
    try {
      _list = await _repository.getAllAdminAccounts();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load datas: $e');
    }
    fetchingData = false;
  }

  Future<void> fetchAllAccountsofEnterprise() async {
    try {
      
      notifyListeners();
    } catch (e) {
      throw Exception('Fail to load data: $e');
    }
  }
}
