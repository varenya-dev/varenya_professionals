// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_password_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePasswordDto _$UpdatePasswordDtoFromJson(Map<String, dynamic> json) {
  return UpdatePasswordDto(
    oldPassword: json['oldPassword'] as String,
    newPassword: json['newPassword'] as String,
  );
}

Map<String, dynamic> _$UpdatePasswordDtoToJson(UpdatePasswordDto instance) =>
    <String, dynamic>{
      'oldPassword': instance.oldPassword,
      'newPassword': instance.newPassword,
    };
