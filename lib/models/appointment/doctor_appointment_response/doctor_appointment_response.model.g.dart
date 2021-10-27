// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_appointment_response.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorAppointmentResponse _$DoctorAppointmentResponseFromJson(
    Map<String, dynamic> json) {
  return DoctorAppointmentResponse(
    appointment:
        Appointment.fromJson(json['appointment'] as Map<String, dynamic>),
    patient: Patient.fromJson(json['patient'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DoctorAppointmentResponseToJson(
        DoctorAppointmentResponse instance) =>
    <String, dynamic>{
      'appointment': instance.appointment,
      'patient': instance.patient,
    };
