import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_category.model.g.dart';

@HiveType(typeId: 10)
@JsonSerializable()
class PostCategory {
  @HiveField(0, defaultValue: '')
  final String id;

  @HiveField(1, defaultValue: '')
  final String categoryName;

  const PostCategory({
    required this.id,
    required this.categoryName,
  });

  factory PostCategory.fromJson(Map<String, dynamic> json) =>
      _$PostCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$PostCategoryToJson(this);
}
