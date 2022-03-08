import 'package:flutter/material.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';
import 'package:varenya_professionals/widgets/appointment/appointment_day.widget.dart';

class AppointmentDayList extends StatefulWidget {
  final DateTime selectedDate;
  final List<DateTime> dates;
  final Function onSelect;

  const AppointmentDayList({
    Key? key,
    required this.selectedDate,
    required this.dates,
    required this.onSelect,
  }) : super(key: key);

  @override
  _AppointmentDayListState createState() => _AppointmentDayListState();
}

class _AppointmentDayListState extends State<AppointmentDayList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: responsiveConfig(
          context: context,
          large: MediaQuery.of(context).size.height * 0.03,
          medium: MediaQuery.of(context).size.height * 0.03,
          small: MediaQuery.of(context).size.height * 0.03,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: this
            .widget
            .dates
            .map(
              (date) => AppointmentDay(
                selected: this.widget.selectedDate.isAtSameMomentAs(date),
                dateTime: date,
                onSelected: () => this.widget.onSelect(date),
              ),
            )
            .toList(),
      ),
    );
  }
}
