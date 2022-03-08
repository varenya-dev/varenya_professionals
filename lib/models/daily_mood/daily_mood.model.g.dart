// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_mood.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyMood _$DailyMoodFromJson(Map<String, dynamic> json) => DailyMood(
      date: DailyMood.timestampFromJson(json['date'] as Timestamp),
      mood: json['mood'] as int? ?? 1,
    );

Map<String, dynamic> _$DailyMoodToJson(DailyMood instance) => <String, dynamic>{
      'date': DailyMood.timestampToJson(instance.date),
      'mood': instance.mood,
    };
