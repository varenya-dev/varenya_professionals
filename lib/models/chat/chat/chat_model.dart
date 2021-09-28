import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class Chat {
  String id;
  String userId;
  String message;

  @JsonKey(fromJson: timestampFromJson, toJson: timestampToJson)
  DateTime timestamp;

  Chat({
    required this.id,
    required this.userId,
    required this.message,
    required this.timestamp,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);

  static DateTime timestampFromJson(Timestamp ts) => ts.toDate();

  static Timestamp timestampToJson(DateTime dateTime) =>
      Timestamp.fromDate(dateTime);
}