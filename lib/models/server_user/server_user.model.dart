import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_professionals/enum/roles.enum.dart';

part 'server_user.model.g.dart';

@JsonSerializable()
class ServerUser {
  String id;
  String firebaseId;
  Roles role;

  ServerUser({
    required this.id,
    required this.firebaseId,
    required this.role,
  });

  factory ServerUser.fromJson(Map<String, dynamic> json) =>
      _$ServerUserFromJson(json);

  Map<String, dynamic> toJson() => _$ServerUserToJson(this);
}
