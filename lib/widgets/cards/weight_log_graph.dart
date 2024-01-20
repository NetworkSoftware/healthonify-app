import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/tracker_models/weight_log.dart';
import 'package:healthonify_mobile/models/wm/goals_model.dart';
import 'package:healthonify_mobile/widgets/drop_downs/filter_dropdown.dart';

class WeightLogGraph extends StatefulWidget {
  final List<WeightLog> weightLogData;
  final WeightGoalModel weightGoalData;

  const WeightLogGraph(
      {required this.weightLogData, required this.weightGoalData, super.key});

  @override
  State<WeightLogGraph> createState() => _WeightLogGraphState();
}

class _WeightLogGraphState extends State<WeightLogGraph> {
  double? graphScrollWidth;
  double maxYValue = 0.0;

  @override
  void initState() {
    super.initState();
    if (double.parse(widget.weightGoalData.goalWeight!) >
        double.parse(widget.weightGoalData.startingWeight!)) {
      maxYValue = (double.parse(widget.weightGoalData.goalWeight!) + 10) / 2;
    } else {
      maxYValue =
          (double.parse(widget.weightGoalData.startingWeight!) + 10) / 2;
    }

    setState(() {
      filterValue = filterOptions[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (filterValue == filterOptions[0]) {
      graphScrollWidth = MediaQuery.of(context).size.width;
    } else if (filterValue == filterOptions[1]) {
      graphScrollWidth = MediaQuery.of(context).size.width * 3.8;
    } else if (filterValue == filterOptions[2]) {
      graphScrollWidth = MediaQuery.of(context).size.width * 7.45;
    } else if (filterValue == filterOptions[3]) {
      graphScrollWidth = MediaQuery.of(context).size.width * 11.1;
    }

    return SizedBox(
      height: 320,
      width: MediaQuery.of(context).size.width * 0.96,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: 330,
            width: MediaQuery.of(context).size.width * 0.94,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 10, top: 20, bottom: 20),
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        getTitlesWidget: getTitles,
                        reservedSize: 46,
                        showTitles: true,
                      ),
                    ),
                    topTitles: AxisTitles(),
                    bottomTitles: AxisTitles(),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    horizontalInterval: 4,
                  ),
                  lineTouchData: LineTouchData(enabled: false),
                  maxY: maxYValue,
                  lineBarsData: widget.weightLogData.map(
                    (d) {
                      List<FlSpot> weights = List.generate(
                        widget.weightLogData.length,
                        (int index) {
                          return FlSpot(
                            double.parse(index.toString()),
                            widget.weightLogData[index].weight! / 2,
                          );
                        },
                        growable: false,
                      );
                      return LineChartBarData(
                        dotData: FlDotData(show: true),

                        //!even after reversing the list, the graph is displayed in the same manner
                        spots: weights.reversed.toList(),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    int? values = value.truncate();
    int? valText = values * 2;
    // log(valText.toString());
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(valText.toStringAsFixed(0)),
    );
  }
}
