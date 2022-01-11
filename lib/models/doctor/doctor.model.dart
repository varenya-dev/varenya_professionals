import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_professionals/models/specialization/specialization.model.dart';

part 'doctor.model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class Doctor {
  @HiveField(0, defaultValue: '')
  String id;

  @HiveField(1, defaultValue: '')
  @JsonKey(defaultValue: '')
  String imageUrl;

  @HiveField(2, defaultValue: '')
  @JsonKey(defaultValue: '')
  String fullName;

  @HiveField(3, defaultValue: '')
  @JsonKey(defaultValue: '')
  String clinicAddress;

  @HiveField(4, defaultValue: 0.0)
  @JsonKey(defaultValue: 0.0)
  double cost;

  @HiveField(5, defaultValue: '')
  @JsonKey(defaultValue: '')
  String jobTitle;

  @HiveField(6)
  DateTime shiftStartTime;

  @HiveField(7)
  DateTime shiftEndTime;

  @HiveField(8, defaultValue: [])
  @JsonKey(defaultValue: [])
  List<Specialization> specializations;

  Doctor({
    required this.id,
    this.imageUrl = '',
    this.fullName = '',
    this.clinicAddress = '',
    this.cost = 0.0,
    this.jobTitle = '',
    this.specializations = const [],
    required this.shiftStartTime,
    required this.shiftEndTime,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}
