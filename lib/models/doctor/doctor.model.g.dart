// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Doctor _$DoctorFromJson(Map<String, dynamic> json) {
  return Doctor(
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
  );
}

Map<String, dynamic> _$DoctorToJson(Doctor instance) => <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'fullName': instance.fullName,
      'clinicAddress': instance.clinicAddress,
      'cost': instance.cost,
      'jobTitle': instance.jobTitle,
      'specializations': instance.specializations,
    };
