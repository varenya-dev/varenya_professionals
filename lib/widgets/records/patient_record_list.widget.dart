import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varenya_professionals/constants/emojis.constant.dart';
import 'package:varenya_professionals/models/daily_mood/daily_mood.model.dart';
import 'package:varenya_professionals/models/daily_mood_data/daily_mood_data.model.dart';

class PatientRecordList extends StatelessWidget {
  final DailyMoodData dailyMoodData;

  const PatientRecordList({
    Key? key,
    required this.dailyMoodData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.dailyMoodData.moods.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        DailyMood dailyMood = this.dailyMoodData.moods[index];

        return ListTile(
          title: Text(
            DateFormat.yMd().add_jm().format(dailyMood.date),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          trailing: Text(
            EMOJIS[dailyMood.mood - 1],
          ),
        );
      },
    );
  }
}
