import 'package:json_annotation/json_annotation.dart';

part 'post_image.model.g.dart';

@JsonSerializable()
class PostImage {
  final String id;
  final String imageUrl;

  const PostImage({
    required this.id,
    required this.imageUrl,
  });

  factory PostImage.fromJson(Map<String, dynamic> json) =>
      _$PostImageFromJson(json);

  Map<String, dynamic> toJson() => _$PostImageToJson(this);
}
