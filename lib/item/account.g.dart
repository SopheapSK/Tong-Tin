// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountItem _$AccountItemFromJson(Map<String, dynamic> json) {
  return AccountItem(
      json['account'] as String,
      json['currency'] as String,
      json['account_type'] as String,
      json['limit'] as String,
      json['balance'] as String,
      json['active'] as bool,
      json['blocked'] as bool,
      json['name'] as String,
      json['till_number'] as String,
      json['shop_name'] as String);
}

Map<String, dynamic> _$AccountItemToJson(AccountItem instance) =>
    <String, dynamic>{
      'account': instance.account,
      'currency': instance.currency,
      'account_type': instance.accountType,
      'limit': instance.limit,
      'balance': instance.balance,
      'active': instance.active,
      'blocked': instance.blocked,
      'name': instance.name,
      'till_number': instance.tillNumber,
      'shop_name': instance.shopName
    };
