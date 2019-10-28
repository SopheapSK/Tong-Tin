// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) {
  return Token(
      refreshToken: json['refresh_token'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      grantType: json['grant_type'] as String,
      clientId: json['client_id'] as String,
      clientSecret: json['client_secret'] as String,
      clientVersion: json['client_version'] as String,
      applicationId: json['application_id'] as String,
      deviceId: json['device_id'] as String);
}

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'refresh_token': instance.refreshToken,
      'username': instance.username,
      'password': instance.password,
      'grant_type': instance.grantType,
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret,
      'client_version': instance.clientVersion,
      'application_id': instance.applicationId,
      'device_id': instance.deviceId
    };
