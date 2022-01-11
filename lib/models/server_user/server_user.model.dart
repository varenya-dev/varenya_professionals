import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:varenya_professionals/enum/roles.enum.dart';
import 'package:varenya_professionals/models/doctor/doctor.model.dart';
import 'package:varenya_professionals/models/server_user/random_name/random_name.model.dart';

part 'server_user.model.g.dart';

@HiveType(typeId: 5)
@JsonSerializable()
class ServerUser {

  @HiveField(0, defaultValue: '')
  String id;

  @HiveField(1, defaultValue: '')
  @JsonKey(defaultValue: '')
  String firebaseId;

  @HiveField(2, defaultValue: Roles.PROFESSIONAL)
  Roles role;

  @HiveField(3)
  @JsonKey(defaultValue: null)
  Doctor? doctor;

  @HiveField(4)
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
