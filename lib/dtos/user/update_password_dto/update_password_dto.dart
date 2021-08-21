import 'package:json_annotation/json_annotation.dart';

part 'update_password_dto.g.dart';

@JsonSerializable()
class UpdatePasswordDto {
  final String oldPassword;
  final String newPassword;

  UpdatePasswordDto({
    required this.oldPassword,
    required this.newPassword,
  });

  factory UpdatePasswordDto.fromJson(Map<String, dynamic> json) =>
      _$UpdatePasswordDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePasswordDtoToJson(this);
}
