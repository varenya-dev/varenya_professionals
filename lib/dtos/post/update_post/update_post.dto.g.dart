// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_post.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePostDto _$UpdatePostDtoFromJson(Map<String, dynamic> json) =>
    UpdatePostDto(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UpdatePostDtoToJson(UpdatePostDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'images': instance.images,
      'categories': instance.categories,
    };
