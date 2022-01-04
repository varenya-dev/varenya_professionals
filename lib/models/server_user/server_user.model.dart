import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_professionals/enum/roles.enum.dart';
import 'package:varenya_professionals/models/doctor/doctor.model.dart';
import 'package:varenya_professionals/models/server_user/random_name/random_name.model.dart';

part 'server_user.model.g.dart';

@JsonSerializable()
class ServerUser {
  String id;

  @JsonKey(defaultValue: '')
  String firebaseId;
  Roles role;

  @JsonKey(defaultValue: null)
  Doctor? doctor;

  @JsonKey(defaultValue: null)
  RandomName? randomName;

  ServerUser({
    required this.id,
    required this.firebaseId,
    required this.role,
    required this.doctor,
    required this.randomName,
  });

  factory ServerUser.fromJson(Map<String, dynamic> json) =>
      _$ServerUserFromJson(json);

  Map<String, dynamic> toJson() => _$ServerUserToJson(this);
}
