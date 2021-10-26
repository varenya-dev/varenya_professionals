import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_professionals/enum/job.enum.dart';
import 'package:varenya_professionals/enum/specialization.enum.dart';

part 'create_update_doctor.dto.g.dart';

@JsonSerializable()
class CreateOrUpdateDoctorDto {
  String id;

  @JsonKey(defaultValue: '')
  String fullName;

  @JsonKey(defaultValue: '')
  String clinicAddress;

  @JsonKey(defaultValue: 0.0)
  double cost;

  @JsonKey(defaultValue: Job.THERAPIST)
  Job jobTitle;

  @JsonKey(defaultValue: [])
  List<Specialization> specializations;

  CreateOrUpdateDoctorDto({
    required this.id,
    required this.fullName,
    required this.clinicAddress,
    required this.cost,
    required this.jobTitle,
    required this.specializations,
  });

  factory CreateOrUpdateDoctorDto.fromJson(Map<String, dynamic> json) =>
      _$CreateOrUpdateDoctorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrUpdateDoctorDtoToJson(this);
}
