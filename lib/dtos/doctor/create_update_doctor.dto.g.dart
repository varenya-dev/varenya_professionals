// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_update_doctor.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrUpdateDoctorDto _$CreateOrUpdateDoctorDtoFromJson(
    Map<String, dynamic> json) {
  return CreateOrUpdateDoctorDto(
    fullName: json['fullName'] as String,
    imageUrl: json['imageUrl'] as String,
    jobTitle: json['jobTitle'] as String,
    clinicAddress: json['clinicAddress'] as String,
    cost: (json['cost'] as num).toDouble(),
    specializations: (json['specializations'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$CreateOrUpdateDoctorDtoToJson(
        CreateOrUpdateDoctorDto instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'imageUrl': instance.imageUrl,
      'jobTitle': instance.jobTitle,
      'clinicAddress': instance.clinicAddress,
      'cost': instance.cost,
      'specializations': instance.specializations,
    };
