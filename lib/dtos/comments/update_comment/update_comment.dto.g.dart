// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_comment.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCommentDto _$UpdateCommentDtoFromJson(Map<String, dynamic> json) =>
    UpdateCommentDto(
      comment: json['comment'] as String,
      commentId: json['commentId'] as String,
    );

Map<String, dynamic> _$UpdateCommentDtoToJson(UpdateCommentDto instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'commentId': instance.commentId,
    };
