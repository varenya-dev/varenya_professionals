import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'random_name.model.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class RandomName {
  @HiveField(0, defaultValue: '')
  final String id;

  @HiveField(1, defaultValue: '')
  final String randomName;

  const RandomName({
    required this.id,
    required this.randomName,
  });

  factory RandomName.fromJson(Map<String, dynamic> json) =>
      _$RandomNameFromJson(json);

  Map<String, dynamic> toJson() => _$RandomNameToJson(this);
}
