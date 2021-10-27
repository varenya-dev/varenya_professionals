import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_professionals/enum/job.enum.dart';
import 'package:varenya_professionals/enum/specialization.enum.dart';

part 'doctor.model.g.dart';

@JsonSerializable()
class Doctor {
  String id;

  @JsonKey(defaultValue: '')
  String imageUrl;

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

  Doctor({
    required this.id,
    this.imageUrl = '',
    this.fullName = '',
    this.clinicAddress = '',
    this.cost = 0.0,
    this.jobTitle = Job.THERAPIST,
    this.specializations = const [],
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}