import 'package:hive/hive.dart';

part 'post_type.enum.g.dart';

@HiveType(typeId: 11)
enum PostType {
  @HiveField(0)
  Post,

  @HiveField(1)
  Comment,
}
