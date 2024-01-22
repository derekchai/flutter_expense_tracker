import 'package:flutter_testing/models/transaction.dart';
import 'package:collection/collection.dart';


class Account {
  String name;
  List<Transaction> transactions; 

  double get balance {
    if (transactions.isEmpty) {
      return 0;
    }
    return transactions.map<double>((transaction) => transaction.amount).sum;
  }

  Account(this.name, this.transactions);
}