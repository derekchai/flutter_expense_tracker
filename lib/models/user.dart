import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_testing/models/account.dart';
import 'package:flutter_testing/models/transaction.dart';

Account _defaultAccount = Account("Default Account", <Transaction>[]);

class UserModel extends ChangeNotifier {

  final List<Account> _accounts = [_defaultAccount];

  Account selectedAccount = _defaultAccount;

  UnmodifiableListView<Account> get accounts => UnmodifiableListView(_accounts);

  void addAccount(Account account) {
    _accounts.add(account);
    notifyListeners();
  }

  void selectAccount(int index) {
    selectedAccount = _accounts[index];
    notifyListeners();
  }

  void addTransaction(Account account, Transaction transaction) {
    account.transactions.add(transaction);
    notifyListeners();
  }
}