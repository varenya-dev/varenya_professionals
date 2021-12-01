// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_booked_appointments.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchBookedAppointments _$FetchBookedAppointmentsFromJson(
        Map<String, dynamic> json) =>
    FetchBookedAppointments(
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$FetchBookedAppointmentsToJson(
        FetchBookedAppointments instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
    };
