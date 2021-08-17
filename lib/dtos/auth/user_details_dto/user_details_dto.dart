import 'package:json_annotation/json_annotation.dart';

part 'user_details_dto.g.dart';

@JsonSerializable()
class UserDetailsDto {
  final String fullName;

  @JsonKey(includeIfNull: true)
  final String? image;

  UserDetailsDto({
    required this.fullName,
    this.image,
  });

  factory UserDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailsDtoToJson(this);
}
