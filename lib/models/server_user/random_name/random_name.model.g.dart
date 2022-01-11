// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'random_name.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RandomNameAdapter extends TypeAdapter<RandomName> {
  @override
  final int typeId = 3;

  @override
  RandomName read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RandomName(
      id: fields[0] == null ? '' : fields[0] as String,
      randomName: fields[1] == null ? '' : fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RandomName obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.randomName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RandomNameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RandomName _$RandomNameFromJson(Map<String, dynamic> json) => RandomName(
      id: json['id'] as String,
      randomName: json['randomName'] as String,
    );

Map<String, dynamic> _$RandomNameToJson(RandomName instance) =>
    <String, dynamic>{
      'id': instance.id,
      'randomName': instance.randomName,
    };
