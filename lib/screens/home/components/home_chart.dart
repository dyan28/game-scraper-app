import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_two_play/generated/fonts.gen.dart';
import 'package:tap_two_play/utils/app_colors.dart';
import 'package:tap_two_play/utils/color_extensions.dart';

class BarChartHistory extends ConsumerStatefulWidget {
  BarChartHistory({super.key});

  List<Color> get availableColors => const <Color>[
        AppColors.contentColorPurple,
        AppColors.contentColorYellow,
        AppColors.contentColorBlue,
        AppColors.contentColorOrange,
        AppColors.contentColorPink,
        AppColors.contentColorRed,
      ];

  final Color barBackgroundColor =
      AppColors.contentColorWhite.darken().withValues(alpha: 0.3);
  final Color barColor = AppColors.contentColorBlue;
  final Color touchedBarColor = AppColors.contentColorGreen;

  @override
  ConsumerState<BarChartHistory> createState() => BarChartHistoryState();
}

class BarChartHistoryState extends ConsumerState<BarChartHistory> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: BarChart(
                      mainBarData(
                        data: [],
                        maxStudyTime: 60,
                      ),
                      duration: animDuration,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 8,
    int maxValue = 60,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;

    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColor.darken(80))
              : const BorderSide(color: Colors.blue, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 60,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(List<dynamic> record) =>
      List.generate(23, (i) {
        Map<int, double> dailyStudyMinutes = {};

        for (int i = 1; i <= 7; i++) {
          dailyStudyMinutes[i] = 0.0;
        }

        for (var record in record) {
          if (record.date != null && record.totalStudyTime != null) {
            final int weekday = record.date!.weekday;
            final double minutes = record.totalStudyTime!.inMinutes.toDouble();
            dailyStudyMinutes[weekday] =
                (dailyStudyMinutes[weekday] ?? 0.0) + minutes;
          }
        }

        final int weekdayForCurrentColumn = (i + DateTime.monday);

        final double totalMinutesForDay =
            dailyStudyMinutes[weekdayForCurrentColumn] ?? 0.0;

        return makeGroupData(i, Random().nextInt(23).toDouble() + 6,
            isTouched: i == touchedIndex);
      });

  BarChartData mainBarData({
    List<dynamic> data = const [],
    required int maxStudyTime,
  }) {
    var noOfSections = 6;

    var yAxisLabelTexts = [
      0,
      maxStudyTime / noOfSections,
      (maxStudyTime / noOfSections) * 2,
      (maxStudyTime / noOfSections) * 3,
      (maxStudyTime / noOfSections) * 4,
      (maxStudyTime / noOfSections) * 5,
      maxStudyTime,
    ].map((item) => item.floor()).toList();


    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.center,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '$rodIndex\n',
              const TextStyle(
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: const TextStyle(
                    color: Colors.blue, //widget.touchedBarColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              return leftTitles(value, meta, yAxisLabelTexts);
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(
        data,
      ),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    var style = const TextStyle(
      color: AppColors.black1,
      fontWeight: FontWeight.bold,
      fontSize: 10,
      fontFamily: FontFamily.sFProDisplayLight,
    );
    Widget text;
    if (value % 6 == 0) {
      text = Text(
        '${value.round()}:00',
        style: style,
      );
    } else {
      text = Text(
        '',
        style: style,
      );
    }

    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: text,
    );
  }

  Widget leftTitles(double value, TitleMeta meta, List<int> yAxisLabelTexts) {
    var style = const TextStyle(
      color: AppColors.black1,
      fontWeight: FontWeight.bold,
      fontSize: 10,
      fontFamily: FontFamily.sFProDisplayLight,
    );
    String? text;
    if (value == yAxisLabelTexts[0]) {
      text = '0p';
    } else if (value == yAxisLabelTexts[1]) {
      text = '${yAxisLabelTexts[1]}p';
    } else if (value == yAxisLabelTexts[2]) {
      text = '${yAxisLabelTexts[2]}p';
    } else if (value == yAxisLabelTexts[3]) {
      text = '${yAxisLabelTexts[3]}p';
    } else if (value == yAxisLabelTexts[4]) {
      text = '${yAxisLabelTexts[4]}p';
    } else if (value == yAxisLabelTexts[5]) {
      text = '${yAxisLabelTexts[5]}p';
    } else if (value == yAxisLabelTexts[6]) {
      text = '${yAxisLabelTexts[6]}p';
    } else {
      return Container();
    }

    return SideTitleWidget(
      meta: meta,
      space: 0,
      child: Text(text, style: style),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(23, (i) {
        return makeGroupData(
          i,
          Random().nextInt(23).toDouble() + 6,
          barColor: widget
              .availableColors[Random().nextInt(widget.availableColors.length)],
        );
      }),
      gridData: const FlGridData(show: false),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}
