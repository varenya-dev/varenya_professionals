import 'package:json_annotation/json_annotation.dart';

part 'update_post.dto.g.dart';

@JsonSerializable()
class UpdatePostDto {
  final String id;
  final String body;
  final List<String> images;
  final List<String> categories;

  const UpdatePostDto({
    required this.id,
    required this.body,
    required this.images,
    required this.categories,
  });

  factory UpdatePostDto.fromJson(Map<String, dynamic> json) =>
      _$UpdatePostDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePostDtoToJson(this);
}
