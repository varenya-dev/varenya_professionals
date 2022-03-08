import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varenya_professionals/models/appointment/doctor_appointment_response/doctor_appointment_response.model.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';

class AppointmentCard extends StatelessWidget {
  final DoctorAppointmentResponse appointment;

  AppointmentCard({
    Key? key,
    required this.appointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          15.0,
        ),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: MediaQuery.of(context).size.height * 0.015,
      ),
      child: Padding(
        padding: EdgeInsets.all(
          responsiveConfig(
            context: context,
            large: MediaQuery.of(context).size.width * 0.025,
            medium: MediaQuery.of(context).size.width * 0.025,
            small: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.017,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.appointment.patient.fullName,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                    ),
                    Text(
                      DateFormat.yMd().format(
                        this.appointment.appointment.scheduledFor,
                      ),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.023,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                    ),
                    Text(
                      DateFormat.jm().format(
                        this.appointment.appointment.scheduledFor,
                      ),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.023,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
