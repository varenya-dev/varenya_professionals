import 'package:json_annotation/json_annotation.dart';

part 'fetch_booked_appointments.dto.g.dart';

@JsonSerializable()
class FetchBookedAppointmentsDto {
  final DateTime date;

  FetchBookedAppointmentsDto({
    required this.date,
  });

  factory FetchBookedAppointmentsDto.fromJson(Map<String, dynamic> json) =>
      _$FetchBookedAppointmentsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FetchBookedAppointmentsDtoToJson(this);
}
