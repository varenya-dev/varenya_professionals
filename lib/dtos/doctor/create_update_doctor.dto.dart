import 'package:json_annotation/json_annotation.dart';

part 'create_update_doctor.dto.g.dart';

@JsonSerializable()
class CreateOrUpdateDoctorDto {
  final String fullName;
  final String imageUrl;
  final String jobTitle;
  final String clinicAddress;
  final double cost;
  final List<String> specializations;
  final DateTime shiftStartTime;
  final DateTime shiftEndTime;

  CreateOrUpdateDoctorDto({
    required this.fullName,
    required this.imageUrl,
    required this.jobTitle,
    required this.clinicAddress,
    required this.cost,
    required this.specializations,
    required this.shiftStartTime,
    required this.shiftEndTime,
  });

  factory CreateOrUpdateDoctorDto.fromJson(Map<String, dynamic> json) =>
      _$CreateOrUpdateDoctorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrUpdateDoctorDtoToJson(this);
}
