import 'package:json_annotation/json_annotation.dart';

part 'specialization.model.g.dart';

@JsonSerializable()
class Specialization {
  final String id;
  final String specialization;
  final DateTime createdAt;
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
