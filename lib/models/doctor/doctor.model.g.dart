// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Doctor _$DoctorFromJson(Map<String, dynamic> json) => Doctor(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      clinicAddress: json['clinicAddress'] as String? ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
      jobTitle: json['jobTitle'] as String? ?? '',
      specializations: (json['specializations'] as List<dynamic>?)
              ?.map((e) => Specialization.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      shiftStartTime: DateTime.parse(json['shiftStartTime'] as String),
      shiftEndTime: DateTime.parse(json['shiftEndTime'] as String),
    );

Map<String, dynamic> _$DoctorToJson(Doctor instance) => <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'fullName': instance.fullName,
      'clinicAddress': instance.clinicAddress,
      'cost': instance.cost,
      'jobTitle': instance.jobTitle,
      'shiftStartTime': instance.shiftStartTime.toIso8601String(),
      'shiftEndTime': instance.shiftEndTime.toIso8601String(),
      'specializations': instance.specializations,
    };
