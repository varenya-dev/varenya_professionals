import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_professionals/models/chat/chat/chat.model.dart';

part 'thread.model.g.dart';

@JsonSerializable()
class Thread {
  String id;
  List<String> participants;
  List<Chat> messages;

  Thread({
    required this.id,
    required this.participants,
    required this.messages,
  });

  factory Thread.fromJson(Map<String, dynamic> json) =>
      _$ThreadFromJson(json);

  Map<String, dynamic> toJson() => _$ThreadToJson(this);
}