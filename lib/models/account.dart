import 'package:flutter_testing/models/category.dart';
import 'package:flutter_testing/models/transaction.dart';
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';


@JsonSerializable() class Account {
  String name;
  List<Transaction> transactions; 

  double get balance {
    if (transactions.isEmpty) {
      return 0;
    }
    return transactions.map<double>((transaction) => transaction.amount).sum;
  }

  Account(this.name, this.transactions);

  double sumOf(CategoryType categoryType) {
    double output = 0;

    for (var transaction in transactions) {
      if (transaction.category.categoryType == categoryType) {
        output += transaction.amount;
      }
    }

    return output;
  }

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);
}