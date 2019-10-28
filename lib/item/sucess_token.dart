
import 'package:json_annotation/json_annotation.dart';
part 'sucess_token.g.dart';

@JsonSerializable()

class TokenResponse {
  @JsonKey(name: 'token')
  final String token;
  TokenResponse({this.token});
  factory TokenResponse.fromJson(Map<String, dynamic> json)  => _$TokenResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);
}