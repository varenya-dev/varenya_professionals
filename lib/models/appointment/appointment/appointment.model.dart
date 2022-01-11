import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_professionals/models/doctor/doctor.model.dart';
import 'package:varenya_professionals/models/server_user/server_user.model.dart';

part 'appointment.model.g.dart';

@HiveType(typeId: 6)
@JsonSerializable()
class Appointment {
  @HiveField(0, defaultValue: '')
  String id;

  @HiveField(1)
  DateTime scheduledFor;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  DateTime updatedAt;

  @HiveField(4)
  ServerUser patientUser;

  @HiveField(5)
  Doctor doctorUser;

  Appointment({
    required this.id,
    required this.scheduledFor,
    required this.createdAt,
    required this.updatedAt,
    required this.patientUser,
    required this.doctorUser,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}
