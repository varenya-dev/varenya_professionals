// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_appointment_response.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoctorAppointmentResponseAdapter
    extends TypeAdapter<DoctorAppointmentResponse> {
  @override
  final int typeId = 8;

  @override
  DoctorAppointmentResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorAppointmentResponse(
      appointment: fields[0] as Appointment,
      patient: fields[1] as Patient,
    );
  }

  @override
  void write(BinaryWriter writer, DoctorAppointmentResponse obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.appointment)
      ..writeByte(1)
      ..write(obj.patient);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorAppointmentResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorAppointmentResponse _$DoctorAppointmentResponseFromJson(
        Map<String, dynamic> json) =>
    DoctorAppointmentResponse(
      appointment:
          Appointment.fromJson(json['appointment'] as Map<String, dynamic>),
      patient: Patient.fromJson(json['patient'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DoctorAppointmentResponseToJson(
        DoctorAppointmentResponse instance) =>
    <String, dynamic>{
      'appointment': instance.appointment,
      'patient': instance.patient,
    };
