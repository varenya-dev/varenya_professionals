import 'package:json_annotation/json_annotation.dart';

part 'delete_post.dto.g.dart';

@JsonSerializable()
class DeletePostDto {
  final String id;

  const DeletePostDto({
    required this.id,
  });

  factory DeletePostDto.fromJson(Map<String, dynamic> json) =>
      _$DeletePostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeletePostDtoToJson(this);
}
