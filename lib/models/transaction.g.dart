// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      json['description'] as String,
      (json['amount'] as num).toDouble(),
      TransactionCategory.fromJson(json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'description': instance.description,
      'amount': instance.amount,
      'category': instance.category,
    };
