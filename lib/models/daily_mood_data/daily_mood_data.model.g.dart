// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_mood_data.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyMoodData _$DailyMoodDataFromJson(Map<String, dynamic> json) =>
    DailyMoodData(
      access: (json['access'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      moods: (json['moods'] as List<dynamic>?)
              ?.map((e) => DailyMood.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$DailyMoodDataToJson(DailyMoodData instance) =>
    <String, dynamic>{
      'access': instance.access,
      'moods': instance.moods,
    };
