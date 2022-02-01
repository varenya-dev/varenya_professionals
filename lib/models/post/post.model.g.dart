// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostAdapter extends TypeAdapter<Post> {
  @override
  final int typeId = 12;

  @override
  Post read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Post(
      id: fields[0] == null ? '' : fields[0] as String,
      postType: fields[1] == null ? PostType.Post : fields[1] as PostType,
      title: fields[9] == null ? '' : fields[9] as String,
      body: fields[2] == null ? '' : fields[2] as String,
      images: fields[3] == null ? [] : (fields[3] as List).cast<PostImage>(),
      user: fields[4] as ServerUser,
      comments: fields[5] == null ? [] : (fields[5] as List).cast<Post>(),
      categories:
          fields[6] == null ? [] : (fields[6] as List).cast<PostCategory>(),
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Post obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.postType)
      ..writeByte(9)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.images)
      ..writeByte(4)
      ..write(obj.user)
      ..writeByte(5)
      ..write(obj.comments)
      ..writeByte(6)
      ..write(obj.categories)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as String,
      postType: $enumDecode(_$PostTypeEnumMap, json['postType']),
      title: json['title'] as String? ?? '',
      body: json['body'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => PostImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      user: ServerUser.fromJson(json['user'] as Map<String, dynamic>),
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => Post.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => PostCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'postType': _$PostTypeEnumMap[instance.postType],
      'title': instance.title,
      'body': instance.body,
      'images': instance.images,
      'user': instance.user,
      'comments': instance.comments,
      'categories': instance.categories,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$PostTypeEnumMap = {
  PostType.Post: 'Post',
  PostType.Comment: 'Comment',
};
