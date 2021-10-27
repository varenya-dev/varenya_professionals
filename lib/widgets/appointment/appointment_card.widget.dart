import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/enum/confirmation_status.enum.dart';
import 'package:varenya_professionals/models/appointment/doctor_appointment_response/doctor_appointment_response.model.dart';
import 'package:varenya_professionals/services/appointment.service.dart';
import 'package:varenya_professionals/utils/snackbar.dart';

class AppointmentCard extends StatefulWidget {
  final DoctorAppointmentResponse appointment;
  final Function refreshAppointments;

  AppointmentCard({
    Key? key,
    required this.appointment,
    required this.refreshAppointments,
  }) : super(key: key);

  @override
  _AppointmentCardState createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  late final AppointmentService _appointmentService;

  @override
  void initState() {
    super.initState();

    this._appointmentService =
        Provider.of<AppointmentService>(context, listen: false);
  }

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
                      'Patient Name: ${widget.appointment.patient.fullName}',
                    ),
                    if (widget.appointment.appointment.status ==
                        ConfirmationStatus.PENDING)
                      Text(
                        widget.appointment.appointment.status
                            .toString()
                            .split('.')[1],
                        textAlign: TextAlign.left,
                      ),
                    if (widget.appointment.appointment.status ==
                        ConfirmationStatus.CONFIRMED)
                      Text(
                        'Confirmed for: ${DateFormat.yMd().add_jm().format(
                              widget.appointment.appointment.scheduledFor
                                  .toLocal(),
                            ).toString()}',
                        textAlign: TextAlign.left,
                      ),
                  ],
                ),
                PopupMenuButton(
                  elevation: 40,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Confirm Appointment"),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: Text("Cancel Appointment"),
                      value: 2,
                    ),
                  ],
                  onSelected: (int? value) async {
                    if (value != null) {
                      if (value == 1) {
                      } else {
                        await this._onDeleteAppointment();
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onDeleteAppointment() async {
    try {
      await this
          ._appointmentService
          .deleteAppointment(widget.appointment.appointment);

      widget.refreshAppointments();

      displaySnackbar(
        'Appointment Cancelled!',
        context,
      );
    } catch (error) {
      displaySnackbar(
        'Something went wrong, please try again later.',
        context,
      );
    }
  }
}
