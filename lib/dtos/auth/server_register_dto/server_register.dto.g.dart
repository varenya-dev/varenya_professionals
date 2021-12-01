// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_register.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerRegisterDto _$ServerRegisterDtoFromJson(Map<String, dynamic> json) =>
    ServerRegisterDto(
      uid: json['uid'] as String,
      role: $enumDecode(_$RolesEnumMap, json['role']),
    );

Map<String, dynamic> _$ServerRegisterDtoToJson(ServerRegisterDto instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'role': _$RolesEnumMap[instance.role],
    };

const _$RolesEnumMap = {
  Roles.MAIN: 'MAIN',
  Roles.PROFESSIONAL: 'PROFESSIONAL',
};
