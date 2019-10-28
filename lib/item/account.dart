
import 'package:json_annotation/json_annotation.dart';
part 'account.g.dart';

@JsonSerializable()
class AccountItem
{
  String account;
  String currency;
  String accountType;
  String limit;
  String balance;
  bool active;
  bool blocked;
  String name;
  String tillNumber;
  String shopName;

  AccountItem(this.account, this.currency, this.accountType, this.limit,
      this.balance, this.active, this.blocked, this.name, this.tillNumber,
      this.shopName);

  factory AccountItem.fromJson(Map<String, dynamic> json) => _$AccountItemFromJson(json);

  Map<String, dynamic> toJson() => _$AccountItemToJson(this);

  @override
  String toString() {
    return 'AccountItem{account: $account, currency: $currency, account_type: $accountType, limit: $limit, balance: $balance, active: $active, blocked: $blocked, name: $name, till_number: $tillNumber, shop_name: $shopName}';
  }


}