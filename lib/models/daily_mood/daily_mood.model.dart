import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_mood.model.g.dart';

@JsonSerializable()
class DailyMood {
  @JsonKey(fromJson: timestampFromJson, toJson: timestampToJson)
  final DateTime date;

  @JsonKey(defaultValue: 1)
  final int mood;

  DailyMood({
    required this.date,
    required this.mood,
  });

  factory DailyMood.fromJson(Map<String, dynamic> json) =>
      _$DailyMoodFromJson(json);

  Map<String, dynamic> toJson() => _$DailyMoodToJson(this);

  static DateTime timestampFromJson(Timestamp ts) => ts.toDate();

  static Timestamp timestampToJson(DateTime dateTime) =>
      Timestamp.fromDate(dateTime);
}
