import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_testing/models/account.dart';
import 'package:flutter_testing/models/category.dart';
import 'package:flutter_testing/models/transaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

Account _defaultAccount = Account("Default Account", <Transaction>[]);

List<TransactionCategory> _defaultCategories = [
  TransactionCategory("Wages", Icons.money.toString(), CategoryType.income),

  TransactionCategory("Food", Icons.fastfood.toString(), CategoryType.expense),
  TransactionCategory("Fuel", Icons.local_gas_station.toString(), CategoryType.expense),
  TransactionCategory("Entertainment", Icons.theater_comedy.toString(), CategoryType.expense),
  TransactionCategory("Groceries", Icons.local_grocery_store.toString(), CategoryType.expense),

  TransactionCategory("Savings", Icons.savings.toString(), CategoryType.savings),
];


@JsonSerializable() class UserModel extends ChangeNotifier {

  UserModel() {
    debugPrint("New UserModel created.");
  }

  List<Account> accountsList = [_defaultAccount];

  List<TransactionCategory> categoriesList = _defaultCategories;

  Account selectedAccount = _defaultAccount;

  UnmodifiableListView<Account> get accounts => UnmodifiableListView(accountsList);

  List<TransactionCategory> get categories => categoriesList;


  void addAccount(Account account) {
    accountsList.add(account);
    notifyListeners();
  }

  void selectAccount(int index) {
    selectedAccount = accountsList[index];
    notifyListeners();
  }

  void addTransaction(Account account, Transaction transaction) {
    account.transactions.add(transaction);
    notifyListeners();
  }

  void removeTransaction(Account account, int index) {
    try {
      account.transactions.removeAt(index);
    } catch (exception) {
      debugPrint("$exception Index in transactions out of bounds!");
    }
  }

  // ? JSON functions.

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}