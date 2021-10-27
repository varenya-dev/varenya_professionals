import 'package:json_annotation/json_annotation.dart';

part 'patient.model.g.dart';

@JsonSerializable()
class Patient {
  String id;
  String fullName;

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
