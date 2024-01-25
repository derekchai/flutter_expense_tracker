// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel()
  ..accountsList = (json['accountsList'] as List<dynamic>)
      .map((e) => Account.fromJson(e as Map<String, dynamic>))
      .toList()
  ..categoriesList = (json['categoriesList'] as List<dynamic>)
      .map((e) => TransactionCategory.fromJson(e as Map<String, dynamic>))
      .toList()
  ..selectedAccount =
      Account.fromJson(json['selectedAccount'] as Map<String, dynamic>);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'accountsList': instance.accountsList,
      'categoriesList': instance.categoriesList,
      'selectedAccount': instance.selectedAccount,
    };
