import 'package:json_annotation/json_annotation.dart';

part 'login_account_dto.g.dart';

@JsonSerializable()
class LoginAccountDto {
  final String emailAddress;
  final String password;

  LoginAccountDto({required this.emailAddress, required this.password});

  factory LoginAccountDto.fromJson(Map<String, dynamic> json) =>
      _$LoginAccountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginAccountDtoToJson(this);
}
