import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varenya_professionals/utils/palette.util.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';

class ShiftSelector extends StatelessWidget {
  final DateTime startTime;
  final DateTime endTime;
  final VoidCallback onShiftStartSelect;
  final VoidCallback onShiftEndSelect;

  ShiftSelector({
    Key? key,
    required this.startTime,
    required this.endTime,
    required this.onShiftStartSelect,
    required this.onShiftEndSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          child: GestureDetector(
            onTap: this.onShiftStartSelect,
            child: Column(
              children: [
                Text('Start'),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                    vertical: MediaQuery.of(context).size.height * 0.01,
                  ),
                  padding: EdgeInsets.all(
                    responsiveConfig(
                      context: context,
                      large: MediaQuery.of(context).size.width * 0.01,
                      medium: MediaQuery.of(context).size.width * 0.01,
                      small: MediaQuery.of(context).size.width * 0.02,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Palette.secondary,
                    borderRadius: BorderRadius.circular(
                      15.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(DateFormat.jm().format(this.startTime).toString()),
                      Icon(
                        Icons.timelapse,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.01,
          ),
          child: GestureDetector(
            onTap: this.onShiftEndSelect,
            child: Column(
              children: [
                Text('End'),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                    vertical: MediaQuery.of(context).size.height * 0.01,
                  ),
                  padding: EdgeInsets.all(
                    responsiveConfig(
                      context: context,
                      large: MediaQuery.of(context).size.width * 0.01,
                      medium: MediaQuery.of(context).size.width * 0.01,
                      small: MediaQuery.of(context).size.width * 0.02,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Palette.secondary,
                    borderRadius: BorderRadius.circular(
                      15.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(DateFormat.jm().format(this.endTime).toString()),
                      Icon(
                        Icons.timelapse,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
