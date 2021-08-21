// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_email_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateEmailDto _$UpdateEmailDtoFromJson(Map<String, dynamic> json) {
  return UpdateEmailDto(
    newEmailAddress: json['newEmailAddress'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$UpdateEmailDtoToJson(UpdateEmailDto instance) =>
    <String, dynamic>{
      'newEmailAddress': instance.newEmailAddress,
      'password': instance.password,
    };
