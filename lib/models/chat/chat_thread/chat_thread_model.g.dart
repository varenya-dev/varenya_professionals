// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_thread_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatThread _$ChatThreadFromJson(Map<String, dynamic> json) => ChatThread(
      id: json['id'] as String,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => Chat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatThreadToJson(ChatThread instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participants': instance.participants,
      'messages': instance.messages,
    };
