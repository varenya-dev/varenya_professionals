import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varenya_professionals/utils/palette.util.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';
import 'package:varenya_professionals/widgets/appointment/appointment_day_list.widget.dart';
import 'package:varenya_professionals/widgets/appointment/appointment_display_list.widget.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  static const routeName = "/appointments-list";

  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  List<DateTime> nextWeekDateList = [];
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    DateTime dateTime = DateTime.now();

    for (int i = 0; i <= 6; i++) {
      DateTime newDateTime = dateTime.add(Duration(days: i));

      nextWeekDateList.add(newDateTime);
    }

    this._selectedDate = nextWeekDateList.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: responsiveConfig(
                context: context,
                large: MediaQuery.of(context).size.width * 0.25,
                medium: MediaQuery.of(context).size.width * 0.25,
                small: 0,
              ),
            ),
            child: Column(
              children: [
                Container(
                  color: Palette.black,
                  width: MediaQuery.of(context).size.width,
                  height: responsiveConfig(
                    context: context,
                    large: MediaQuery.of(context).size.height * 0.3,
                    medium: MediaQuery.of(context).size.height * 0.3,
                    small: MediaQuery.of(context).size.height * 0.23,
                  ),
                  padding: EdgeInsets.all(
                    responsiveConfig(
                      context: context,
                      large: MediaQuery.of(context).size.width * 0.03,
                      medium: MediaQuery.of(context).size.width * 0.03,
                      small: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  child: Text(
                    'Booked\nAppointments',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                AppointmentDayList(
                  selectedDate: this._selectedDate!,
                  dates: this.nextWeekDateList,
                  onSelect: (DateTime date) {
                    setState(() {
                      this._selectedDate = date;
                    });
                  },
                ),
                AppointmentDisplayList(
                  dateTime: this._selectedDate!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
