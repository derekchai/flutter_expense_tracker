import 'package:flutter/material.dart';

enum CategoryType {
  income,
  savings,
  expense,
  noCategory
}

extension CategoryColor on CategoryType {
  Color? get color {
    switch (this) {
      case CategoryType.income:
        return Colors.green;
      case CategoryType.savings:
        return Colors.amber;
      case CategoryType.expense:
        return Colors.red;
      case CategoryType.noCategory:
        return null;
    }
  }
}

class TransactionCategory {
  String name;
  IconData iconData;
  CategoryType categoryType;

  TransactionCategory(this.name, this.iconData, this.categoryType);
}