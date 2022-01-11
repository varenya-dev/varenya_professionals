// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_user.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServerUserAdapter extends TypeAdapter<ServerUser> {
  @override
  final int typeId = 5;

  @override
  ServerUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServerUser(
      id: fields[0] == null ? '' : fields[0] as String,
      firebaseId: fields[1] == null ? '' : fields[1] as String,
      role: fields[2] == null ? Roles.PROFESSIONAL : fields[2] as Roles,
      doctor: fields[3] as Doctor?,
      randomName: fields[4] as RandomName?,
    );
  }

  @override
  void write(BinaryWriter writer, ServerUser obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firebaseId)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.doctor)
      ..writeByte(4)
      ..write(obj.randomName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServerUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
