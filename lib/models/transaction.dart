import 'package:flutter_testing/models/category.dart';

class Transaction {
  String description = "";
  double amount = 0;
  TransactionCategory category;
  

  Transaction(this.description, this.amount, this.category);
}