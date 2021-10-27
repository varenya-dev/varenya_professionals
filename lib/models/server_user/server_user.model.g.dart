// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_user.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerUser _$ServerUserFromJson(Map<String, dynamic> json) {
  return ServerUser(
    id: json['id'] as String,
    firebaseId: json['firebaseId'] as String,
    role: _$enumDecode(_$RolesEnumMap, json['role']),
  );
}

Map<String, dynamic> _$ServerUserToJson(ServerUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firebaseId': instance.firebaseId,
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
