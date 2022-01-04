import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_professionals/enum/post_type.enum.dart';
import 'package:varenya_professionals/models/post/post_category/post_category.model.dart';
import 'package:varenya_professionals/models/post/post_image/post_image.model.dart';
import 'package:varenya_professionals/models/server_user/server_user.model.dart';

part 'post.model.g.dart';

@JsonSerializable()
class Post {
  final String id;
  final PostType postType;
  final String body;

  @JsonKey(defaultValue: const [])
  final List<PostImage> images;
  final ServerUser user;

  @JsonKey(defaultValue: const [])
  final List<Post> comments;

  @JsonKey(defaultValue: const [])
  final List<PostCategory> categories;

  final DateTime createdAt;
  final DateTime updatedAt;

  Post({
    required this.id,
    required this.postType,
    required this.body,
    required this.images,
    required this.user,
    required this.comments,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) =>
      _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
