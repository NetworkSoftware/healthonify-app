import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/trackers/watertracker_func.dart';
import 'package:healthonify_mobile/models/tracker_models/water_intake_model.dart';
import 'package:healthonify_mobile/widgets/drop_downs/filter_dropdown.dart';

class AverageWaterGraph extends StatefulWidget {
  final double maxYcount;
  const AverageWaterGraph({required this.maxYcount, Key? key})
      : super(key: key);

  @override
  State<AverageWaterGraph> createState() => _AverageWaterGraphState();
}

class _AverageWaterGraphState extends State<AverageWaterGraph> {
  ScrollController barChartScroller = ScrollController();
  List<WaterIntake> data = [];

  Future<void> getData(BuildContext context) async {
    try {
      data = await WaterTracker().getAllWaterData(context);
    } catch (e) {
      log("Exception in avg water card");
    }
  }

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
      // height: 300,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Expanded(
        child: Card(
          elevation: 2,
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 10,
              //     vertical: 2,
              //   ),
              //   child: Row(
              //     children: [
              //       Text(
              //         'Average',
              //         style: Theme.of(context).textTheme.bodyLarge,
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 10,
              //     vertical: 2,
              //   ),
              //   child: Row(
              //     children: [
              //       Text(
              //         '3.6 ',
              //         style: Theme.of(context).textTheme.titleLarge,
              //       ),
              //       Text(
              //         'glasses of water',
              //         style: Theme.of(context).textTheme.bodyMedium,
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 10,
              //     vertical: 2,
              //   ),
              //   child: Row(
              //     children: [
              //       Text(
              //         'This week',
              //         style: Theme.of(context).textTheme.bodyMedium,
              //       ),
              //     ],
              //   ),
              // ),
              // Image.asset('assets/icons/graph.png'),
              FilterDropDown(
                onSelected: () {
                  setState(() {});
                },
              ),
              FutureBuilder(
                future: getData(context),
                builder: (context, snapshot) => snapshot.connectionState ==
                        ConnectionState.waiting
                    ? const SizedBox(
                        // height: 330,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      )
                    : data.isEmpty
                        ? const Center(
                            child: Text("No data available"),
                          )
                        : Stack(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: barChartScroller,
                                reverse: true,
                                physics: const BouncingScrollPhysics(),
                                child: SizedBox(
                                  height: 330,
                                  width: graphScrollWidth,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: BarChart(
                                      BarChartData(
                                        titlesData: FlTitlesData(
                                          leftTitles: AxisTitles(),
                                          rightTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              getTitlesWidget: getRightTitles,
                                              reservedSize: 46,
                                              showTitles: true,
                                            ),
                                          ),
                                          topTitles: AxisTitles(),
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              getTitlesWidget: getTitles,
                                              reservedSize: 36,
                                              showTitles: true,
                                            ),
                                          ),
                                        ),
                                        gridData: FlGridData(
                                          show: true,
                                          drawVerticalLine: true,
                                          // verticalInterval: 2,
                                          drawHorizontalLine: true,
                                          // horizontalInterval: 4,
                                        ),
                                        // borderData: FlBorderData(
                                        //   show: false,
                                        // ),
                                        alignment: BarChartAlignment.center,
                                        maxY: widget.maxYcount,
                                        groupsSpace: 30,
                                        barTouchData:
                                            BarTouchData(enabled: true),
                                        // groupsSpace: 30,
                                        barGroups: data
                                            .map(
                                              (d) => BarChartGroupData(
                                                barsSpace: 20,
                                                x: int.parse(
                                                  d.date!,
                                                ),
                                                // showingTooltipIndicators:
                                                //     intList,
                                                barRods: [
                                                  BarChartRodData(
                                                    toY: double.parse(
                                                      d.waterGlass!,
                                                    ),
                                                    width: 20.0,
                                                    color: orange,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(6),
                                                      topRight:
                                                          Radius.circular(6),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   right: 0,
                              //   child: ColoredBox(
                              //     color: Theme.of(context).canvasColor,
                              //     child: SizedBox(
                              //       height: 330,
                              //       width: 30,
                              //       child: Column(
                              //         crossAxisAlignment:
                              //             CrossAxisAlignment.start,
                              //         children: [
                              //           ListView.builder(
                              //             physics:
                              //                 const NeverScrollableScrollPhysics(),
                              //             shrinkWrap: true,
                              //             itemCount: evenNumbers.length,
                              //             itemBuilder: (context, index) {
                              //               return Padding(
                              //                 padding: const EdgeInsets.symmetric(
                              //                   vertical: 7.5,
                              //                 ),
                              //                 child: Padding(
                              //                   padding: const EdgeInsets.only(
                              //                       right: 8.0),
                              //                   child: Text(
                              //                     '${evenNumbers[index]}',
                              //                     style: Theme.of(context)
                              //                         .textTheme
                              //                         .bodySmall,
                              //                     textAlign: TextAlign.right,
                              //                     textScaleFactor: 1,
                              //                   ),
                              //                 ),
                              //               );
                              //             },
                              //           ),
                              //           // const SizedBox(height: 30),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget getRightTitles(double value, TitleMeta meta) {
    int? values = value.truncate();
    int? valText = values;
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(valText.toStringAsFixed(0)),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    // log("bar $value");

    int val = value.toInt();
    var dt = DateTime.fromMillisecondsSinceEpoch(val);
    String dss = DateFormat("E").format(dt);
    String v = DateFormat("dd/MM").format(dt);

    TextStyle? style = Theme.of(context).textTheme.bodySmall;
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
