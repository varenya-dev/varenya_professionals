import 'package:json_annotation/json_annotation.dart';

part 'register_account_dto.g.dart';

@JsonSerializable()
class RegisterAccountDto {
  final String emailAddress;
  final String password;
  final String fullName;
  final String imageUrl;

  RegisterAccountDto({
    required this.fullName,
    required this.imageUrl,
    required this.emailAddress,
    required this.password,
  });

  factory RegisterAccountDto.fromJson(Map<String, dynamic> json) =>
      _$RegisterAccountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterAccountDtoToJson(this);
}
