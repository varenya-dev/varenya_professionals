// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_user.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerUser _$ServerUserFromJson(Map<String, dynamic> json) => ServerUser(
      id: json['id'] as String,
      firebaseId: json['firebaseId'] as String? ?? '',
      role: $enumDecode(_$RolesEnumMap, json['role']),
      doctor: json['doctor'] == null
          ? null
          : Doctor.fromJson(json['doctor'] as Map<String, dynamic>),
      randomName: json['randomName'] == null
          ? null
          : RandomName.fromJson(json['randomName'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ServerUserToJson(ServerUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firebaseId': instance.firebaseId,
      'role': _$RolesEnumMap[instance.role],
      'doctor': instance.doctor,
      'randomName': instance.randomName,
    };

const _$RolesEnumMap = {
  Roles.MAIN: 'MAIN',
  Roles.PROFESSIONAL: 'PROFESSIONAL',
};
