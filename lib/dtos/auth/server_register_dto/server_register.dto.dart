import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_professionals/enum/roles.enum.dart';

part 'server_register.dto.g.dart';

@JsonSerializable()
class ServerRegisterDto {
  final String uid;
  final Roles role;

  ServerRegisterDto({
    required this.uid,
    required this.role,
  });

  factory ServerRegisterDto.fromJson(Map<String, dynamic> json) =>
      _$ServerRegisterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ServerRegisterDtoToJson(this);
}
