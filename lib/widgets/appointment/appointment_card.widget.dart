import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/enum/confirmation_status.enum.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/appointment/doctor_appointment_response/doctor_appointment_response.model.dart';
import 'package:varenya_professionals/services/appointment.service.dart';
import 'package:varenya_professionals/utils/display_bottom_sheet.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    this._appointmentService =
        Provider.of<AppointmentService>(context, listen: false);

    initializeDateFormatting();
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

                  ],
                ),
                PopupMenuButton(
                  elevation: 40,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Cancel Appointment"),
                      value: 2,
                    ),
                  ],
                  onSelected: (int? value) async {
                    if (value != null) {
                      if (value == 1) {
                        this._onConfirmAppointment();
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

  void _onConfirmAppointment() {
    displayBottomSheet(
      context,
      StatefulBuilder(
        builder: (context, setStateInner) => Wrap(
          children: [
            ListTile(
              title: Text('Set Date'),
              trailing: Text(
                DateFormat.yMMMd('en_UK')
                    .format(
                      this._dateTime.toLocal(),
                    )
                    .toString(),
              ),
              onTap: () async {
                DateTime? dateTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(
                    DateTime.now().year + 2,
                  ),
                );

                if (dateTime != null) {
                  setState(
                    () {
                      this._dateTime = DateTime.parse(dateTime.toString());
                    },
                  );

                  setStateInner(() {});
                }
              },
            ),
            ListTile(
              title: Text('Set Time'),
              trailing: Text(
                DateFormat.jm()
                    .format(
                      this._dateTime.toLocal(),
                    )
                    .toString(),
              ),
              onTap: () async {
                TimeOfDay? timeOfDay = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (timeOfDay != null) {
                  setState(
                    () {
                      this._dateTime = this._dateTime.add(
                            new Duration(
                              hours: timeOfDay.hour,
                              minutes: timeOfDay.minute,
                            ),
                          );
                    },
                  );

                  setStateInner(() {});
                }
              },
            ),
            Center(
              child: TextButton(
                onPressed: _onUpdateConfirmation,
                child: Text('Confirm Appointment'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onUpdateConfirmation() async {
    try {
      widget.appointment.appointment.scheduledFor = this._dateTime;

      await this
          ._appointmentService
          .updateAppointment(widget.appointment.appointment);

      widget.refreshAppointments();

      Navigator.of(context).pop();

      displaySnackbar(
        'Appointment Confirmed!',
        context,
      );
    } on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error) {
      print(error);
      displaySnackbar(
        'Something went wrong, please try again later.',
        context,
      );
    }
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
    } on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error) {
      print(error);
      displaySnackbar(
        'Something went wrong, please try again later.',
        context,
      );
    }
  }
}
