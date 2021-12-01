import 'package:json_annotation/json_annotation.dart';

part 'fetch_booked_appointments.dto.g.dart';

@JsonSerializable()
class FetchBookedAppointments {
  final DateTime date;

  FetchBookedAppointments({
    required this.date,
  });

  factory FetchBookedAppointments.fromJson(Map<String, dynamic> json) =>
      _$FetchBookedAppointmentsFromJson(json);

  Map<String, dynamic> toJson() => _$FetchBookedAppointmentsToJson(this);
}
