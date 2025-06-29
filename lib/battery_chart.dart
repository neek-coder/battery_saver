import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BatteryChart extends StatelessWidget {
  final int barsCount;
  final List<BarChartGroupData> Function(double barWidth) barGroups;

  const BatteryChart({
    super.key,
    required this.barsCount,
    required this.barGroups,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 225,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10), // very light shadow
            offset: Offset(0, 2), // slightly down
            blurRadius: 4, // soft blur
            spreadRadius: 0, // no spread
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Last 12 hours'.toUpperCase(),
                style: TextStyle(color: CupertinoColors.systemGrey),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Flexible(
            child: Row(
              children: [
                Flexible(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final barSpace = 0.15 * constraints.maxWidth / barsCount;
                      final barWidth = 0.75 * constraints.maxWidth / barsCount;

                      return BarChart(
                        BarChartData(
                          barGroups: barGroups(barWidth),
                          alignment: BarChartAlignment.spaceBetween,
                          gridData: FlGridData(
                            show: true,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: CupertinoColors.systemGrey4,
                              strokeWidth: 0.25,
                            ),
                            getDrawingVerticalLine: (value) => FlLine(
                              color: CupertinoColors.systemGrey4,
                              strokeWidth: 0.25,
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barTouchData: BarTouchData(),
                          groupsSpace: barSpace,
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '100%',
                        style: TextStyle(color: CupertinoColors.systemGrey),
                      ),
                      Text(
                        '50%',
                        style: TextStyle(color: CupertinoColors.systemGrey),
                      ),
                      Text(
                        '0%',
                        style: TextStyle(color: CupertinoColors.systemGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
