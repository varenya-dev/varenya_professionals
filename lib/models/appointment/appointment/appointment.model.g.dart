// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppointmentAdapter extends TypeAdapter<Appointment> {
  @override
  final int typeId = 6;

  @override
  Appointment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Appointment(
      id: fields[0] == null ? '' : fields[0] as String,
      scheduledFor: fields[1] as DateTime,
      createdAt: fields[2] as DateTime,
      updatedAt: fields[3] as DateTime,
      patientUser: fields[4] as ServerUser,
      doctorUser: fields[5] as Doctor,
    );
  }

  @override
  void write(BinaryWriter writer, Appointment obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.scheduledFor)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.patientUser)
      ..writeByte(5)
      ..write(obj.doctorUser);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
      id: json['id'] as String,
      scheduledFor: DateTime.parse(json['scheduledFor'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      patientUser:
          ServerUser.fromJson(json['patientUser'] as Map<String, dynamic>),
      doctorUser: Doctor.fromJson(json['doctorUser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scheduledFor': instance.scheduledFor.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'patientUser': instance.patientUser,
      'doctorUser': instance.doctorUser,
    };
