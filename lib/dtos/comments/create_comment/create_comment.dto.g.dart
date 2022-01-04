// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_comment.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCommentDto _$CreateCommentDtoFromJson(Map<String, dynamic> json) =>
    CreateCommentDto(
      comment: json['comment'] as String,
      postId: json['postId'] as String,
    );

Map<String, dynamic> _$CreateCommentDtoToJson(CreateCommentDto instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'postId': instance.postId,
    };
