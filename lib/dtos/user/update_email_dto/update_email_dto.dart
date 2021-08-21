import 'package:json_annotation/json_annotation.dart';

part 'update_email_dto.g.dart';

@JsonSerializable()
class UpdateEmailDto {
  final String newEmailAddress;
  final String password;

  UpdateEmailDto({
    required this.newEmailAddress,
    required this.password,
  });

  factory UpdateEmailDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateEmailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateEmailDtoToJson(this);
}
