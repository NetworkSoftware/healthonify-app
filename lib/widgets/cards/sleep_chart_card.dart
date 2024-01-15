
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/trackers/sleep_tracker_func.dart';
import 'package:healthonify_mobile/providers/trackers/sleep_tracker.dart';
import 'package:healthonify_mobile/widgets/drop_downs/filter_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SleepCardChart extends StatefulWidget {
  const SleepCardChart({Key? key}) : super(key: key);

  @override
  State<SleepCardChart> createState() => _SleepCardChartState();
}

class _SleepCardChartState extends State<SleepCardChart> {
  List<int> intList = List.generate(
    17,
    (int index) => index,
    growable: false,
  );

  double? graphScrollWidth;
  var evenNumbers = [];

  @override
  void initState() {
    super.initState();

    for (var ele in intList) {
      if (ele.isEven) {
        evenNumbers.add(ele);
      }
    }
    evenNumbers = evenNumbers.reversed.toList();

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
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              // Row(
              //   children: [
              //     Text(
              //       'Avg time in bed',
              //       style: Theme.of(context).textTheme.bodyLarge,
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 2),
              // Row(
              //   children: [
              //     Text(
              //       '4 ',
              //       style: Theme.of(context).textTheme.titleMedium,
              //     ),
              //     Text(
              //       'hr ',
              //       style: Theme.of(context).textTheme.bodyLarge,
              //     ),
              //     Text(
              //       '20 ',
              //       style: Theme.of(context).textTheme.titleMedium,
              //     ),
              //     Text(
              //       'min',
              //       style: Theme.of(context).textTheme.bodyLarge,
              //     ),
              //   ],
              // ),
              FilterDropDown(
                onSelected: () {
                  setState(() {});
                },
              ),
              SizedBox(
                // height: 300,
                child: FutureBuilder(
                  future: SleepTrackerFunc().getAllSleepLogs(context),
                  builder: (context, snapshot) => snapshot.connectionState ==
                          ConnectionState.waiting
                      ? const SizedBox(
                          height: 330,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Consumer<SleepTrackerProvider>(
                              builder: (context, data, child) {
                                return data.allSleepData.isEmpty
                                    ? const Center(
                                        child: Text("No Data Available"),
                                      )
                                    : Stack(
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            reverse: true,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: SizedBox(
                                              height: 330,
                                              width: graphScrollWidth,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: BarChart(
                                                  BarChartData(
                                                    titlesData: FlTitlesData(
                                                      leftTitles: AxisTitles(),
                                                      rightTitles: AxisTitles(),
                                                      topTitles: AxisTitles(),
                                                      bottomTitles: AxisTitles(
                                                        sideTitles: SideTitles(
                                                          getTitlesWidget:
                                                              getTitles,
                                                          reservedSize: 36,
                                                          showTitles: true,
                                                        ),
                                                      ),
                                                    ),
                                                    gridData: FlGridData(
                                                      show: true,
                                                      drawVerticalLine: true,
                                                      drawHorizontalLine: true,
                                                      horizontalInterval: 4,
                                                    ),
                                                    alignment: BarChartAlignment
                                                        .center,
                                                    maxY: 16,
                                                    groupsSpace: 30,
                                                    barTouchData: BarTouchData(
                                                        enabled: true),
                                                    // groupsSpace: 30,
                                                    barGroups:
                                                        data.allSleepData.map(
                                                      (d) {
                                                        String seconds =
                                                            d.sleepDurationInSeconds ??
                                                                "0";

                                                        double sleepSeconds =
                                                            double.parse(
                                                                seconds);

                                                        double sleepHours =
                                                            sleepSeconds *
                                                                0.0002778;

                                                        double
                                                            roundedOffSleepHours =
                                                            double.parse(
                                                          sleepHours
                                                              .toStringAsFixed(
                                                                  2),
                                                        );

                                                        return BarChartGroupData(
                                                          barsSpace: 20,
                                                          x: int.parse(d.date!),
                                                          barRods: [
                                                            BarChartRodData(
                                                              toY:
                                                                  roundedOffSleepHours,
                                                              width: 20.0,
                                                              color: orange,
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        6),
                                                                topRight: Radius
                                                                    .circular(
                                                                        6),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ).toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: ColoredBox(
                                              color:
                                                  Theme.of(context).canvasColor,
                                              child: SizedBox(
                                                height: 330,
                                                width: 30,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ListView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          evenNumbers.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 7.5,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 8.0),
                                                            child: Text(
                                                              '${evenNumbers[index]}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              textScaleFactor:
                                                                  1,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                              },
                            ),
                          ],
                        ),
                ),
              ),
              // const SizedBox(height: 10),
              // Row(
              //   children: [
              //     Text(
              //       'This month',
              //       style: Theme.of(context).textTheme.bodyLarge,
              //     ),
              //   ],
              // ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    int val = value.toInt();

    var dt = DateTime.fromMillisecondsSinceEpoch(val);
    String dss = DateFormat("E").format(dt);
    String v = DateFormat("dd/MM").format(dt);
    TextStyle? style = Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: 12,
        );
    Widget text;
    switch (dss) {
      case "Mon":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Tue":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Wed":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Thu":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Fri":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Sat":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      case "Sun":
        text = Text(
          v,
          style: style,
          textScaleFactor: 1,
        );
        break;
      default:
        text = Text(
          '',
          style: style,
          textScaleFactor: 1,
        );
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}
