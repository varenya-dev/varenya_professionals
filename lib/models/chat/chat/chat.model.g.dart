// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      id: json['id'] as String,
      userId: json['userId'] as String,
      message: json['message'] as String,
      timestamp: Chat.timestampFromJson(json['timestamp'] as Timestamp),
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'message': instance.message,
      'timestamp': Chat.timestampToJson(instance.timestamp),
    };
