import 'package:flutter_testing/models/category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable() class Transaction {
  String description = "";
  double amount = 0;
  TransactionCategory category;
  DateTime date;

  Transaction(this.description, this.amount, this.category, this.date);

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}