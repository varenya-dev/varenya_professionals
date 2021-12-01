import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varenya_professionals/widgets/appointment/appointment_display_list.widget.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  static const routeName = "/appointments-list";

  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  List<DateTime> nextWeekDateList = [];

  @override
  void initState() {
    super.initState();

    DateTime dateTime = DateTime.now();

    for (int i = 0; i <= 6; i++) {
      DateTime newDateTime = dateTime.add(Duration(days: i));

      nextWeekDateList.add(newDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: nextWeekDateList.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Booked Appointments'),
          bottom: TabBar(
            isScrollable: true,
            tabs: this
                .nextWeekDateList
                .map(
                  (dateTime) => Tab(
                text: DateFormat.yMMMd().format(dateTime).toString(),
              ),
            )
                .toList(),
          ),
        ),
        body: TabBarView(
          children: this
              .nextWeekDateList
              .map(
                (dateTime) => AppointmentDisplayList(
              dateTime: dateTime,
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}
