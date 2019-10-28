import 'package:json_annotation/json_annotation.dart';

part 'login_token.g.dart';

@JsonSerializable()


class Token  {

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  final String username;
  final String password;

  @JsonKey(name: 'grant_type')
  final String grantType;
  @JsonKey(name: 'client_id')
  final String clientId;
  @JsonKey(name: 'client_secret')
  final String clientSecret;
  @JsonKey(name: 'client_version')
  final String clientVersion;
  @JsonKey(name: 'application_id')
  final String applicationId;
  @JsonKey(name: 'device_id')
  final String deviceId;


  Token({this.refreshToken, this.username, this.password, this.grantType,
    this.clientId, this.clientSecret, this.clientVersion, this.applicationId,
    this.deviceId});


  factory Token.fromJson(Map<String, dynamic> json)  => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
  /*
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;
    map["grant_type"] = grantType;
    map["client_id"] = clientId;
    map["client_secret"] = clientSecret;
    map["client_version"] = clientVersion;
    map["application_id"] = applicationId;
    map["device_id"] = deviceId;

    return map;
  }
  */
}

