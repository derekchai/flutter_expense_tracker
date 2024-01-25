// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionCategory _$TransactionCategoryFromJson(Map<String, dynamic> json) =>
    TransactionCategory(
      json['name'] as String,
      json['iconData'] as String,
      $enumDecode(_$CategoryTypeEnumMap, json['categoryType']),
    );

Map<String, dynamic> _$TransactionCategoryToJson(
        TransactionCategory instance) =>
    <String, dynamic>{
      'name': instance.name,
      'iconData': instance.iconData,
      'categoryType': _$CategoryTypeEnumMap[instance.categoryType]!,
    };

const _$CategoryTypeEnumMap = {
  CategoryType.income: 'income',
  CategoryType.savings: 'savings',
  CategoryType.expense: 'expense',
  CategoryType.noCategory: 'noCategory',
};
