import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varenya_professionals/constants/emojis.constant.dart';
import 'package:varenya_professionals/models/daily_mood/daily_mood.model.dart';
import 'package:varenya_professionals/widgets/records/mood_view.widget.dart';

class DailyMoodDisplay extends StatelessWidget {
  final DailyMood dailyMood;

  const DailyMoodDisplay({
    Key? key,
    required this.dailyMood,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(
          15.0,
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ListTile(
                title: Text(
                  'Mood score: ${this.dailyMood.mood}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  DateFormat.yMMMd().add_jm().format(
                        this.dailyMood.date,
                      ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: MoodView(
                  emojiPath: EMOJIS_IMG[this.dailyMood.mood - 1],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
