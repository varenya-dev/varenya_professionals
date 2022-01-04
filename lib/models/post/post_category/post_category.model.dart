import 'package:json_annotation/json_annotation.dart';

part 'post_category.model.g.dart';

@JsonSerializable()
class PostCategory {
  final String id;
  final String categoryName;

  const PostCategory({
    required this.id,
    required this.categoryName,
  });

  factory PostCategory.fromJson(Map<String, dynamic> json) =>
      _$PostCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$PostCategoryToJson(this);
}
