// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_booked_appointments.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchBookedAppointmentsDto _$FetchBookedAppointmentsDtoFromJson(
        Map<String, dynamic> json) =>
    FetchBookedAppointmentsDto(
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$FetchBookedAppointmentsDtoToJson(
        FetchBookedAppointmentsDto instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
    };
