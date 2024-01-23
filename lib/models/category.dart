import 'package:flutter/material.dart';

enum CategoryType {
  income,
  savings,
  expense
}

class TransactionCategory {
  String name;
  IconData iconData;
  CategoryType categoryType;

  TransactionCategory(this.name, this.iconData, this.categoryType);
}