import 'package:json_annotation/json_annotation.dart';

part 'delete_comment.dto.g.dart';

@JsonSerializable()
class DeleteCommentDto {
  final String commentId;

  DeleteCommentDto({
    required this.commentId,
  });

  factory DeleteCommentDto.fromJson(Map<String, dynamic> json) =>
      _$DeleteCommentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteCommentDtoToJson(this);
}
