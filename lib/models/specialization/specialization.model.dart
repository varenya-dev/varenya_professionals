import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'specialization.model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class Specialization {
  @HiveField(0, defaultValue: '')
  final String id;

  @HiveField(1, defaultValue: '')
  final String specialization;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final DateTime updatedAt;

  Specialization({
    required this.id,
    required this.specialization,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Specialization.fromJson(Map<String, dynamic> json) =>
      _$SpecializationFromJson(json);

  Map<String, dynamic> toJson() => _$SpecializationToJson(this);
}
