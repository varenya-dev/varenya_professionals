import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:varenya_professionals/constants/emojis.constant.dart';
import 'package:varenya_professionals/models/daily_mood/daily_mood.model.dart';
import 'package:varenya_professionals/models/daily_mood_data/daily_mood_data.model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:varenya_professionals/utils/palette.util.dart';

class MoodChart extends StatefulWidget {
  final DailyMoodData dailyMoodData;

  const MoodChart({
    Key? key,
    required this.dailyMoodData,
  }) : super(key: key);

  @override
  _MoodChartState createState() => _MoodChartState();
}

class _MoodChartState extends State<MoodChart> {
  List<DailyMood> _dailyProgressData = [];

  @override
  void initState() {
    super.initState();
    this._dailyProgressData = this.widget.dailyMoodData.moods.length > 7
        ? this.widget.dailyMoodData.moods.sublist(
              this.widget.dailyMoodData.moods.length - 7,
              this.widget.dailyMoodData.moods.length,
            )
        : this.widget.dailyMoodData.moods;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.40,
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.07,
        left: MediaQuery.of(context).size.width * 0.03,
        right: MediaQuery.of(context).size.width * 0.03,
      ),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Palette.secondary,
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map(
                      (barSpot) {
                    final flSpot = barSpot;

                    return LineTooltipItem(
                      EMOJIS[flSpot.y.toInt() - 1],
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text:
                          '\n${DateFormat.yMMMd().format(this._dailyProgressData[flSpot.x.toInt()].date)}',
                        ),
                      ],
                    );
                  },
                ).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              preventCurveOverShooting: true,
              colors: [
                Palette.primary,
              ],
              spots: this
                  ._dailyProgressData
                  .map(
                    (e) => FlSpot(
                      this._dailyProgressData.indexOf(e).toDouble(),
                      e.mood.toDouble(),
                    ),
                  )
                  .toList(),
              isCurved: true,
              barWidth: 5,
              dotData: FlDotData(
                show: true,
              ),
              belowBarData: BarAreaData(
                show: true,
                colors: [
                  Palette.primary.withOpacity(
                    0.1,
                  ),
                ],
              ),
            ),
          ],
          minY: 0,
          maxY: 6,
          titlesData: FlTitlesData(
            topTitles: SideTitles(
              showTitles: false,
            ),
            rightTitles: SideTitles(
              showTitles: false,
            ),
            bottomTitles: SideTitles(
              interval: 1,
              showTitles: true,
              rotateAngle: 90.0,
              getTitles: (value) => DateFormat.yMMMd().format(
                this._dailyProgressData[value.toInt()].date,
              ),
              margin: 20,
              getTextStyles: (BuildContext context, _) => TextStyle(
                fontSize: 11.0,
              ),
            ),
            leftTitles: SideTitles(
              showTitles: true,
              getTitles: (value) {
                if (value.toInt() > EMOJIS.length || (value.toInt() - 1) < 0)
                  return '';
                return EMOJIS[value.toInt() - 1];
              },
              interval: 1,
              margin: 12,
              getTextStyles: (BuildContext context, _) => TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          gridData: FlGridData(
            show: false,
          ),
        ),
      ),
    );
  }
}
