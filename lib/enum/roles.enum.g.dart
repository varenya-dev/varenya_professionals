// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roles.enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RolesAdapter extends TypeAdapter<Roles> {
  @override
  final int typeId = 4;

  @override
  Roles read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Roles.MAIN;
      case 1:
        return Roles.PROFESSIONAL;
      default:
        return Roles.MAIN;
    }
  }

  @override
  void write(BinaryWriter writer, Roles obj) {
    switch (obj) {
      case Roles.MAIN:
        writer.writeByte(0);
        break;
      case Roles.PROFESSIONAL:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RolesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
