import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varenya_professionals/utils/palette.util.dart';

class AppointmentDay extends StatelessWidget {
  final DateTime dateTime;
  final VoidCallback onSelected;
  final bool selected;

  const AppointmentDay({
    Key? key,
    required this.selected,
    required this.dateTime,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          DateFormat.E().format(this.dateTime).substring(0, 2).toUpperCase(),
        ),
        GestureDetector(
          onTap: this.onSelected,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: CircleAvatar(
              backgroundColor:
              this.selected ? Palette.primary : Palette.secondary,
              child: Text(
                this.dateTime.day.toString(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
