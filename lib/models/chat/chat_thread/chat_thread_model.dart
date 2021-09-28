import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_professionals/models/chat/chat/chat_model.dart';

part 'chat_thread_model.g.dart';

@JsonSerializable()
class ChatThread {
  String id;
  List<String> participants;
  List<Chat> messages;

  ChatThread({
    required this.id,
    required this.participants,
    required this.messages,
  });

  factory ChatThread.fromJson(Map<String, dynamic> json) =>
      _$ChatThreadFromJson(json);

  Map<String, dynamic> toJson() => _$ChatThreadToJson(this);
}