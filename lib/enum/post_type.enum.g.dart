// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_type.enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostTypeAdapter extends TypeAdapter<PostType> {
  @override
  final int typeId = 11;

  @override
  PostType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PostType.Post;
      case 1:
        return PostType.Comment;
      default:
        return PostType.Post;
    }
  }

  @override
  void write(BinaryWriter writer, PostType obj) {
    switch (obj) {
      case PostType.Post:
        writer.writeByte(0);
        break;
      case PostType.Comment:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
