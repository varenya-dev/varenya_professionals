import 'package:json_annotation/json_annotation.dart';

part 'create_post.dto.g.dart';

@JsonSerializable()
class CreatePostDto {
  final String title;
  final String body;
  final List<String> images;
  final List<String> categories;

  const CreatePostDto({
    required this.title,
    required this.body,
    required this.images,
    required this.categories,
  });

  factory CreatePostDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostDtoToJson(this);
}
