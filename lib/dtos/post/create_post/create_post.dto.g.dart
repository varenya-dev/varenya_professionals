// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePostDto _$CreatePostDtoFromJson(Map<String, dynamic> json) =>
    CreatePostDto(
      title: json['title'] as String,
      body: json['body'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CreatePostDtoToJson(CreatePostDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'images': instance.images,
      'categories': instance.categories,
    };
