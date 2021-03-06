import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_professionals/models/appointment/appointment/appointment.model.dart';
import 'package:varenya_professionals/models/patient/patient.model.dart';

part 'doctor_appointment_response.model.g.dart';

@HiveType(typeId: 8)
@JsonSerializable()
class DoctorAppointmentResponse {
  @HiveField(0)
  Appointment appointment;

  @HiveField(1)
  Patient patient;

  DoctorAppointmentResponse({
    required this.appointment,
    required this.patient,
  });

  factory DoctorAppointmentResponse.fromJson(Map<String, dynamic> json) =>
      _$DoctorAppointmentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorAppointmentResponseToJson(this);
}
