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
    jobTitle:
        _$enumDecodeNullable(_$JobEnumMap, json['jobTitle']) ?? Job.THERAPIST,
    specializations: (json['specializations'] as List<dynamic>?)
            ?.map((e) => _$enumDecode(_$SpecializationEnumMap, e))
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
      'jobTitle': _$JobEnumMap[instance.jobTitle],
      'specializations': instance.specializations
          .map((e) => _$SpecializationEnumMap[e])
          .toList(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$JobEnumMap = {
  Job.THERAPIST: 'THERAPIST',
  Job.PSYCHOLOGIST: 'PSYCHOLOGIST',
  Job.COUNSELOR: 'COUNSELOR',
  Job.PSYCHIATRIST: 'PSYCHIATRIST',
};

const _$SpecializationEnumMap = {
  Specialization.DEPRESSION: 'DEPRESSION',
  Specialization.ANXIETY: 'ANXIETY',
  Specialization.BIPOLAR: 'BIPOLAR',
  Specialization.AUTISM: 'AUTISM',
  Specialization.PSYCHOSIS: 'PSYCHOSIS',
  Specialization.PTSD: 'PTSD',
};
