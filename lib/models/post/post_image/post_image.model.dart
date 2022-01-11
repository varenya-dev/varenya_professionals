import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_image.model.g.dart';

@HiveType(typeId: 9)
@JsonSerializable()
class PostImage {
  @HiveField(0, defaultValue: '')
  final String id;

  @HiveField(1, defaultValue: '')
  final String imageUrl;

  const PostImage({
    required this.id,
    required this.imageUrl,
  });

  factory PostImage.fromJson(Map<String, dynamic> json) =>
      _$PostImageFromJson(json);

  Map<String, dynamic> toJson() => _$PostImageToJson(this);
}
