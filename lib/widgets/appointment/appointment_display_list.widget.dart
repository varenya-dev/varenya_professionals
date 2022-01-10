import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/dtos/fetch_booked_appointments/fetch_booked_appointments.dto.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/appointment/doctor_appointment_response/doctor_appointment_response.model.dart';
import 'package:varenya_professionals/services/appointment.service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';

import 'appointment_card.widget.dart';

class AppointmentDisplayList extends StatefulWidget {
  final DateTime dateTime;

  const AppointmentDisplayList({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  @override
  _AppointmentDisplayListState createState() => _AppointmentDisplayListState();
}

class _AppointmentDisplayListState extends State<AppointmentDisplayList> {
  late final AppointmentService _appointmentService;

  @override
  void initState() {
    super.initState();

    this._appointmentService =
        Provider.of<AppointmentService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._appointmentService.fetchAppointmentsByDay(
            FetchBookedAppointmentsDto(
              date: this.widget.dateTime,
            ),
          ),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<DoctorAppointmentResponse>> snapshot,
      ) {
        if (snapshot.hasError) {
          switch (snapshot.error.runtimeType) {
            case ServerException:
              {
                ServerException exception = snapshot.error as ServerException;
                return Text(exception.message);
              }
            default:
              {
                log.e(
                  "AppointmentDisplayList Error",
                  snapshot.error,
                  snapshot.stackTrace,
                );
                return Text("Something went wrong, please try again later");
              }
          }
        }

        if (snapshot.connectionState == ConnectionState.done) {
          List<DoctorAppointmentResponse> appointments = snapshot.data!;

          return ListView.builder(
            itemCount: appointments.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              DoctorAppointmentResponse appointmentResponse =
                  appointments[index];

              return AppointmentCard(
                appointment: appointmentResponse,
              );
            },
          );
        }

        return Column(
          children: [
            CircularProgressIndicator(),
          ],
        );
      },
    );
  }
}
