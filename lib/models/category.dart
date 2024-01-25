import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

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

@JsonSerializable() class TransactionCategory {
  String name;
  String iconData;
  CategoryType categoryType;

  TransactionCategory(this.name, this.iconData, this.categoryType);

  factory TransactionCategory.fromJson(Map<String, dynamic> json) => _$TransactionCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionCategoryToJson(this);
}