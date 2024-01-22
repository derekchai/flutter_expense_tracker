import 'package:flutter/material.dart';

class Transaction {
  String description = "";
  double amount = 0;
  Icon icon = const Icon(Icons.attach_money);

  Transaction(this.description, this.amount, this.icon);
}