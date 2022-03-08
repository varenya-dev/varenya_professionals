import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_professionals/models/daily_mood/daily_mood.model.dart';

part 'daily_mood_data.model.g.dart';

@JsonSerializable()
class DailyMoodData {

  @JsonKey(defaultValue: [])
  final List<String> access;

  @JsonKey(defaultValue: [])
  final List<DailyMood> moods;

  DailyMoodData({
    required this.access,
    required this.moods,
  });

  factory DailyMoodData.fromJson(Map<String, dynamic> json) =>
      _$DailyMoodDataFromJson(json);

  Map<String, dynamic> toJson() => _$DailyMoodDataToJson(this);
}
