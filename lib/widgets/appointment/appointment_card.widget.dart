import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varenya_professionals/models/appointment/doctor_appointment_response/doctor_appointment_response.model.dart';

class AppointmentCard extends StatelessWidget {
  final DoctorAppointmentResponse appointment;

  AppointmentCard({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patient Name: ${appointment.patient.fullName}',
                    ),
                    Text(
                      'Timing: ${DateFormat.jm().format(appointment.appointment.scheduledFor).toString()}',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
