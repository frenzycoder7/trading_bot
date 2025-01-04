import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trading_bot/core/apis/models/7_days_profit.model.dart';
import 'package:trading_bot/core/extensions/context_extension.dart';
import 'package:trading_bot/core/extensions/double.extension.dart';

class SevenDaysDataChart extends StatefulWidget {
  final List<SevenDaysProfit> data;

  const SevenDaysDataChart({
    super.key,
    required this.data,
  });

  final Color leftBarColor = Colors.green;
  final Color rightBarColor = Colors.yellow;

  @override
  State<StatefulWidget> createState() => SevenDaysDataChartState();
}

class SevenDaysDataChartState extends State<SevenDaysDataChart> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;
  double maxYValue = 0;

  @override
  void initState() {
    super.initState();

    final items = widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return makeGroupData(
        index,
        data.profit.toDouble(),
        data.tc.toDouble(),
      );
    }).toList();

    // Calculate maxY based on the data
    maxYValue =
        widget.data.map((e) => e.tc.toDouble()).reduce((a, b) => a > b ? a : b);
    maxYValue = maxYValue.toPrecision(2);
    rawBarGroups = items;
    showingBarGroups = rawBarGroups;
    debugPrint("maxYValue: $maxYValue");
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                makeTransactionsIcon(),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Last 7 days',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Spacer(),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          color: Colors.green,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Text('Profit'),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 15,
                          width: 15,
                          color: Colors.yellow,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Text('Trades'),
                      ],
                    ))
              ],
            ),
            const SizedBox(
              height: 38,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: maxYValue + 5,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: ((group) {
                        return Colors.grey;
                      }),
                      getTooltipItem: (a, b, c, d) {
                        // Provide meaningful tooltip data
                        final profit = widget.data[a.x.toInt()].profit;
                        final trades = widget.data[a.x.toInt()].tc;
                        return BarTooltipItem(
                          'Profit: ${profit.toStringAsFixed(2)} \n Trades: ${trades.toStringAsFixed(2)}',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod
                              in showingBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum /
                              showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .length;

                          showingBarGroups[touchedGroupIndex] =
                              showingBarGroups[touchedGroupIndex].copyWith(
                            barRods: showingBarGroups[touchedGroupIndex]
                                .barRods
                                .map((rod) {
                              return rod.copyWith(
                                toY: avg,
                              );
                            }).toList(),
                          );
                        }
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
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    // Find the maximum value from both profit and trades
    double maxValue = 0;
    for (var group in rawBarGroups) {
      for (var rod in group.barRods) {
        if (rod.toY > maxValue) {
          maxValue = rod.toY;
        }
      }
    }

    // Format number to K, M, B notation
    String formatNumber(double number) {
      if (number >= 1000000000) {
        return '${(number / 1000000000).toStringAsFixed(1)}B';
      }
      if (number >= 1000000) {
        return '${(number / 1000000).toStringAsFixed(1)}M';
      }
      if (number >= 1000) {
        return '${(number / 1000).toStringAsFixed(1)}K';
      }
      return number.toStringAsFixed(1);
    }

    // Show labels at 0%, 33%, 66%, and 100% of the max value
    if (value == 0) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 0,
        child: const Text('0', style: style),
      );
    } else if (value == maxValue / 3) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 0,
        child: Text(formatNumber(maxValue / 3), style: style),
      );
    } else if (value == maxValue * 2 / 3) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 0,
        child: Text(formatNumber(maxValue * 2 / 3), style: style),
      );
    } else if (value == maxValue) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 0,
        child: Text(formatNumber(maxValue), style: style),
      );
    }

    return Container();
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final text = Text(
      widget.data[value.toInt()].id.formatDate(),
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
