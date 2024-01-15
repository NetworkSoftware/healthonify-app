import 'dart:developer';

import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/func/trackers/step_tracker.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/trackers/heart_rate.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/drop_downs/filter_dropdown.dart';
import 'package:healthonify_mobile/widgets/tab_app_bar.dart';
import 'package:provider/provider.dart';

class HeartRateScreen extends StatefulWidget {
  String? userId;

  HeartRateScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<HeartRateScreen> createState() => _HeartRateScreenState();
}

class _HeartRateScreenState extends State<HeartRateScreen>
    with TickerProviderStateMixin {
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    //getHrHistoryLogs();
    // initTracker().then((value) async {
    //   return getHrLogs();
    // });
    initTracker().then((value) async {
      return await getHrHistoryLogs();
    });
  //  initTracker();
  }



  Future<void> initTracker({bool isManual = false}) async {
    //
    //setState(() {});
    try {
      //


      List<HeartRateData> response = await HeartRateTracker().initHeart();

      Map<String, dynamic> data;

      if (isManual) {
        if (value == null) {
          Fluttertoast.showToast(msg: "Please enter a value");
          return;
        }
        data = {
          "userId": widget.userId ??
              Provider.of<UserData>(context, listen: false).userData.id,
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "manualData": [
            {
              "value": value,
              "time": "${DateTime.now().hour}:${DateTime.now().minute}"
            }
          ]
        };
      } else {
        data = {
          "userId": Provider.of<UserData>(context, listen: false).userData.id,
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "platformData": List.generate(
            response.length,
            (index) => {
              "value": response[index].value,
              "platformName": response[index].platform,
              "time": response[index].time,
            },
          ),
        };
      }

      log(data.toString());
      if (!mounted) return;
      LoadingDialog().onLoadingDialog("Loading", context);
      await Provider.of<HeartRateTrackerProvider>(context, listen: false)
          .postHRLogs(data);
    } on HttpException catch (e) {
      log("heart rate log error http $e");
      // Fluttertoast.showToast(msg: "Unable to update heart rate log");
    } catch (e, trace) {
      log("sleep log error $e");
      log("trace1 ${trace.toString()}");
      // Fluttertoast.showToast(msg: 'Unable to update heart rate log');
    } finally {
      setState(() {});
      // Navigator.of(context).pop();
    }
  }

  List<HeartRate> data = [];
  List<HeartRate> historyData = [];
  String? value;

  Future<void> getHrLogs() async {
    LoadingDialog().onLoadingDialog("Loading", context);
    try {
      data = await Provider.of<HeartRateTrackerProvider>(context, listen: false)
          .getHRLogs(
              "?userId=${Provider.of<UserData>(context, listen: false).userData.id}&date=${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
              false);
      setState(() {});
    } on HttpException catch (e) {
      log("heart rate log error http $e");
      Fluttertoast.showToast(msg: "Unable to update heart rate log");
    } catch (e, trace) {
      log("sleep log error $e");
      log("trace2 ${trace.toString()}");
      Fluttertoast.showToast(msg: 'Unable to update heart rate log');
    } finally {
      setState(() {});
      Navigator.of(context).pop();
    }
  }

  Future<void> getHrHistoryLogs() async {
   // LoadingDialog().onLoadingDialog("Loading", context);
    try {
      historyData = await Provider.of<HeartRateTrackerProvider>(context,
              listen: false)
          .getHRHistoryLogs(
              "?userId=${Provider.of<UserData>(context, listen: false).userData.id}",
              false);
      setState(() {});
    } on HttpException catch (e) {
      log("heart rate log error http $e");
      Fluttertoast.showToast(msg: "Unable to update heart rate log");
    } catch (e, trace) {
      log("sleep log error $e");
      log("trace3 ${trace.toString()}");
      Fluttertoast.showToast(msg: 'Unable to update heart rate log');
    } finally {
      setState(() {});
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      appBar: TabAppBar(
        appBarTitle: 'Heart Rate',
        actionWIdget2: kSharedPreferences.getString("role") != "ROLE_EXPERT" ?
        Padding(
          padding: const EdgeInsets.only(top: 15, right: 10),
          child: GestureDetector(
              onTap: () {
                showAppointmentSheet();
              },
              child: const Text(
                "+ Add Log",
                style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
              )),
        ) : const SizedBox(),
        bottomWidget: ColoredBox(
            color: Theme.of(context).appBarTheme.backgroundColor!,
            child: customTabBar(context, tabController)),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: TabBarView(
            controller: tabController,
            physics: const BouncingScrollPhysics(),
            children: [
              build1(),
              const WeeklyHeartRateTab(),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: kSharedPreferences.getString("role") != "ROLE_EXPERT"
      //     ? InkWell(
      //         onTap: () {
      //           showAlert();
      //         },
      //         child: SizedBox(
      //           height: 50,
      //           child: GradientButton(
      //             title: 'MEASURE HEART RATE',
      //             func: () {
      //               showAppointmentSheet();
      //             },
      //             gradient: orangeGradient,
      //           ),
      //         ),
      //       )
      //     : const SizedBox(),
    );
  }

  void showAppointmentSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Theme.of(context).canvasColor,
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: SizedBox(
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).canvasColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter your heart rate',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.grey),
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                        onChanged: (val) {
                          value = val;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await initTracker(isManual: true);
                          //if (!mounted) return;
                          Navigator.of(context).pop();
                        //  Navigator.of(context).pop();
                          getHrLogs();
                          getHrHistoryLogs();
                        },
                        child: Text(
                          'Add log',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget build1() {
    String maxHR = "0";
    String avgHR = "0";
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    for (int i = 0; i < historyData.length; i++) {
      if (historyData[i].date!.substring(0, 10) == formattedDate) {
        maxHR = historyData[i].maxHr!.toStringAsFixed(0);
        avgHR = historyData[i].avgHr.toString();
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //const SizedBox(height: 16),
        // Padding(
        //   padding: const EdgeInsets.all(16),
        //   child: Text(
        //     'STATS',
        //     style: Theme.of(context).textTheme.labelLarge,
        //   ),
        // ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("assets/images/heart.png",
                            height: 30, width: 30),
                        const SizedBox(width: 5),
                        Row(
                          children: [
                            Text(
                              'Max HR',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                  fontSize: 16,
                                      color: orange,
                                      fontWeight: FontWeight.bold),
                            ),
                            //const SizedBox(width: 5),
                            Text(
                              ' $maxHR',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                  fontSize: 16,
                                      color: orange,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // const SizedBox(width: 5),
              Expanded(
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Row(
                      children: [
                        Image.asset("assets/images/heart.png",
                            height: 30, width: 30),
                        const SizedBox(width: 5),
                        Row(
                          children: [
                            Text(
                              'Average HR',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                  fontSize: 16,
                                      color: orange,
                                      fontWeight: FontWeight.bold),
                            ),
                            // /const SizedBox(width: 5),
                            Text(
                              ' $avgHR',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontSize: 16,
                                      color: orange,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Logs',
            style:
                Theme.of(context).textTheme.labelLarge!.copyWith(color: orange),
          ),
        ),
        if (historyData.isNotEmpty)
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: historyData.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            StringDateTimeFormat()
                                .stringtDateFormatHeartRate(
                                historyData[index].date!),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey),
                          ),
                          Text(
                            historyData[index].avgHr.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge,
                          ),
                          // Expanded(
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Row(
                          //         children: [
                          //
                          //         ],
                          //       ),
                          //       Text(
                          //         StringDateTimeFormat()
                          //             .stringtDateFormatHeartRate(
                          //                 historyData[index].date!),
                          //         overflow: TextOverflow.ellipsis,
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .bodySmall!
                          //             .copyWith(color: Colors.grey),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: Icon(
                          //     Icons.edit_note_rounded,
                          //     color: orange,
                          //     size: 34,
                          //   ),
                          //   splashRadius: 20,
                          // ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  // Widget build2() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(top: 10, left: 16, bottom: 6),
  //         child: Text(
  //           'This Week',
  //           style: Theme.of(context).textTheme.labelLarge,
  //         ),
  //       ),
  //       // Image.asset('assets/icons/graph.png'),
  //       SizedBox(
  //         height: 120,
  //         width: double.infinity,
  //         child: Center(
  //           child: Text(
  //             'No data available',
  //             style: Theme.of(context).textTheme.bodyMedium,
  //           ),
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Text(
  //           'STATS',
  //           style: Theme.of(context).textTheme.labelLarge,
  //         ),
  //       ),
  //       Expanded(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const SizedBox(height: 20),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: Column(
  //                     children: const [
  //                       Text('Max HR'),
  //                       SizedBox(height: 20),
  //                       Text('Average HR'),
  //                     ],
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Column(
  //                     children: const [
  //                       Text('-'),
  //                       SizedBox(height: 20),
  //                       Text('-'),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  void showAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Heart rate Tracker not connected',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('CONNECT'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      barrierDismissible: false,
    );
  }

  TabBar customTabBar(context, TabController controller) => TabBar(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('DAILY'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('WEEKLY'),
          ),
        ],
        labelStyle: Theme.of(context).textTheme.labelMedium,
        indicatorColor: Colors.red,
        indicatorWeight: 2.5,
      );
}

class WeeklyHeartRateTab extends StatefulWidget {
  const WeeklyHeartRateTab({super.key});

  @override
  State<WeeklyHeartRateTab> createState() => _WeeklyHeartRateTabState();
}

class _WeeklyHeartRateTabState extends State<WeeklyHeartRateTab> {
  ScrollController barChartScroller = ScrollController();

  bool isLoading = true;

  List<HeartRate> data = [];

  Future<void> getHrLogs() async {
    try {
      data = await Provider.of<HeartRateTrackerProvider>(context, listen: false)
          .getHRLogs(
              "?userId=${Provider.of<UserData>(context, listen: false).userData.id}&date=${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
              true);
    } on HttpException catch (e) {
      log("heart rate log error http $e");
      Fluttertoast.showToast(msg: "Unable to update heart rate log");
    } catch (e) {
      log("weekly heart rate error: $e");
      Fluttertoast.showToast(msg: 'Unable to update heart rate log');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  double? graphScrollWidth;
  String averageHr = '0';
  String maxHr = '0';

  @override
  void initState() {
    super.initState();

    getHrLogs();

    setState(() {
      filterValue = filterOptions[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    graphScrollWidth = MediaQuery.of(context).size.width;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 16, bottom: 6),
                child: Text(
                  'This Week',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Card(
              //           child: Container(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 10, vertical: 10),
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(10),
              //                 color: Colors.white),
              //             child: Row(
              //               // mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 Image.asset("assets/images/heart.png",
              //                     height: 30, width: 30),
              //                 const SizedBox(width: 5),
              //                 Row(
              //                   children: [
              //                     Text(
              //                       'Max HR',
              //                       style: Theme.of(context)
              //                           .textTheme
              //                           .labelLarge!
              //                           .copyWith(
              //                           color: orange,
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                     const SizedBox(width: 5),
              //                     Text(
              //                       maxHr,
              //                       style: Theme.of(context)
              //                           .textTheme
              //                           .labelLarge!
              //                           .copyWith(
              //                           color: orange,
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         child: Card(
              //           child: Container(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 10, vertical: 10),
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(10),
              //                 color: Colors.white),
              //             child: Row(
              //               children: [
              //                 Image.asset("assets/images/heart.png",
              //                     height: 30, width: 30),
              //                 const SizedBox(width: 5),
              //                 Row(
              //                   children: [
              //                     Text(
              //                       'Average HR',
              //                       style: Theme.of(context)
              //                           .textTheme
              //                           .labelLarge!
              //                           .copyWith(
              //                           color: orange,
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                     const SizedBox(width: 5),
              //                     Text(
              //                       averageHr,
              //                       style: Theme.of(context)
              //                           .textTheme
              //                           .labelLarge!
              //                           .copyWith(
              //                           color: orange,
              //                           fontWeight: FontWeight.bold),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Card(
                  elevation: 2,
                  child: Column(
                    children: [
                      data.isEmpty
                          ? const Center(
                              child: Text("No data available"),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(10),
                              child: Stack(
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
                                                  getTitlesWidget:
                                                      getRightTitles,
                                                  reservedSize: 40,
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
                                              drawHorizontalLine: true,
                                            ),
                                            alignment: BarChartAlignment.center,
                                            maxY: 200,
                                            groupsSpace: 30,
                                            barTouchData:
                                                BarTouchData(enabled: true),
                                            barGroups: data.map(
                                              (d) {
                                                averageHr = d.avgHr!.toString();
                                                maxHr = d.maxHr!.toStringAsFixed(0);
                                                double averageHeartRate =
                                                    double.parse(averageHr);

                                                return BarChartGroupData(
                                                  barsSpace: 20,
                                                  x: int.parse(d.date!),
                                                  barRods: [
                                                    BarChartRodData(
                                                      toY: averageHeartRate,
                                                      width: 20.0,
                                                      color: orange,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(6),
                                                        topRight:
                                                            Radius.circular(6),
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
                                ],
                              ),
                            ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset("assets/images/heart.png",
                                  height: 30, width: 30),
                              const SizedBox(width: 5),
                              Row(
                                children: [
                                  Text(
                                    'Max HR',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                        color: orange,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    maxHr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                        color: orange,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Row(
                            children: [
                              Image.asset("assets/images/heart.png",
                                  height: 30, width: 30),
                              const SizedBox(width: 5),
                              Row(
                                children: [
                                  Text(
                                    'Average HR',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                        color: orange,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    averageHr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                        color: orange,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 16),
              // Padding(
              //   padding: const EdgeInsets.all(16),
              //   child: Text(
              //     'STATS',
              //     style: Theme.of(context).textTheme.labelLarge,
              //   ),
              // ),
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     const SizedBox(height: 20),
              //     Row(
              //       children: [
              //         const Expanded(
              //           child: Column(
              //             children: [
              //               Text('Max HR'),
              //               SizedBox(height: 20),
              //               Text('Average HR'),
              //             ],
              //           ),
              //         ),
              //         Expanded(
              //           child: Column(
              //             children: [
              //               Text(maxHr),
              //               const SizedBox(height: 20),
              //               Text(averageHr),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ],
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
