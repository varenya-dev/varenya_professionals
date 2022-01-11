// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_category.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostCategoryAdapter extends TypeAdapter<PostCategory> {
  @override
  final int typeId = 10;

  @override
  PostCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostCategory(
      id: fields[0] == null ? '' : fields[0] as String,
      categoryName: fields[1] == null ? '' : fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PostCategory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCategory _$PostCategoryFromJson(Map<String, dynamic> json) => PostCategory(
      id: json['id'] as String,
      categoryName: json['categoryName'] as String,
    );

Map<String, dynamic> _$PostCategoryToJson(PostCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryName': instance.categoryName,
    };
