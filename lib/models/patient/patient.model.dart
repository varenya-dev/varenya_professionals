import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'patient.model.g.dart';

@HiveType(typeId: 7)
@JsonSerializable()
class Patient {
  @HiveField(0, defaultValue: '')
  String id;

  @HiveField(1, defaultValue: '')
  String fullName;

  @HiveField(2, defaultValue: '')
  @JsonKey(defaultValue: '')
  String imageUrl;

  Patient({
    required this.id,
    required this.fullName,
    required this.imageUrl,
  });

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);

  Map<String, dynamic> toJson() => _$PatientToJson(this);
}
