import 'package:flutter_testing/models/category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable() class Transaction {
  String description = "";
  double amount = 0;
  TransactionCategory category;

  Transaction(this.description, this.amount, this.category);

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}