// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetailsDto _$UserDetailsDtoFromJson(Map<String, dynamic> json) {
  return UserDetailsDto(
    fullName: json['fullName'] as String,
    image: json['image'] as String?,
  );
}

Map<String, dynamic> _$UserDetailsDtoToJson(UserDetailsDto instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'image': instance.image,
    };
