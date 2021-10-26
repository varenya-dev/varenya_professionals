import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_professionals/enum/job.enum.dart';
import 'package:varenya_professionals/enum/specialization.enum.dart';

part 'doctor.model.g.dart';

@JsonSerializable()
class Doctor {
  String id;
  String fullName;
  String clinicAddress;
  String cost;
  Job jobTitle;
  List<Specialization> specializations;

  Doctor({
    required this.id,
    required this.fullName,
    required this.clinicAddress,
    required this.cost,
    required this.jobTitle,
    required this.specializations,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}
