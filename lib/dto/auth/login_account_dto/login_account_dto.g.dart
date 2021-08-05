// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginAccountDto _$LoginAccountDtoFromJson(Map<String, dynamic> json) {
  return LoginAccountDto(
    emailAddress: json['emailAddress'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$LoginAccountDtoToJson(LoginAccountDto instance) =>
    <String, dynamic>{
      'emailAddress': instance.emailAddress,
      'password': instance.password,
    };
