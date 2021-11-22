// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_register.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerRegisterDto _$ServerRegisterDtoFromJson(Map<String, dynamic> json) {
  return ServerRegisterDto(
    uid: json['uid'] as String,
    role: _$enumDecode(_$RolesEnumMap, json['role']),
  );
}

Map<String, dynamic> _$ServerRegisterDtoToJson(ServerRegisterDto instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'role': _$RolesEnumMap[instance.role],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$RolesEnumMap = {
  Roles.MAIN: 'MAIN',
  Roles.PROFESSIONAL: 'PROFESSIONAL',
};
