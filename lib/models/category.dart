import 'package:flutter/material.dart';

enum CategoryType {
  income,
  savings,
  expense
}

class TransactionCategory {
  String name;
  Icon icon;
  CategoryType categoryType;

  TransactionCategory(this.name, this.icon, this.categoryType);
}