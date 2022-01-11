// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_image.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostImageAdapter extends TypeAdapter<PostImage> {
  @override
  final int typeId = 9;

  @override
  PostImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostImage(
      id: fields[0] == null ? '' : fields[0] as String,
      imageUrl: fields[1] == null ? '' : fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PostImage obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostImage _$PostImageFromJson(Map<String, dynamic> json) => PostImage(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$PostImageToJson(PostImage instance) => <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
    };
