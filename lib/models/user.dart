import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_testing/models/account.dart';
import 'package:flutter_testing/models/category.dart';
import 'package:flutter_testing/models/transaction.dart';

Account _defaultAccount = Account("Default Account", <Transaction>[]);

List<TransactionCategory> _defaultCategories = [
  TransactionCategory("Wages", Icons.money, CategoryType.income),

  TransactionCategory("Food", Icons.fastfood, CategoryType.expense),
  TransactionCategory("Fuel", Icons.local_gas_station, CategoryType.expense),
  TransactionCategory("Entertainment", Icons.theater_comedy, CategoryType.expense),
  TransactionCategory("Groceries", Icons.local_grocery_store, CategoryType.expense),
];

class UserModel extends ChangeNotifier {

  final List<Account> _accounts = [_defaultAccount];

  final List<TransactionCategory> _categories = _defaultCategories;

  Account selectedAccount = _defaultAccount;

  UnmodifiableListView<Account> get accounts => UnmodifiableListView(_accounts);

  List<TransactionCategory> get categories => _categories;


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