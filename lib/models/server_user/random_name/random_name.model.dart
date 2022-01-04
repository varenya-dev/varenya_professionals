import 'package:json_annotation/json_annotation.dart';

part 'random_name.model.g.dart';

@JsonSerializable()
class RandomName {
  final String id;
  final String randomName;

  const RandomName({
    required this.id,
    required this.randomName,
  });

  factory RandomName.fromJson(Map<String, dynamic> json) =>
      _$RandomNameFromJson(json);

  Map<String, dynamic> toJson() => _$RandomNameToJson(this);
}
