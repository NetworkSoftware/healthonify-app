import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/all_trackers.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/calorie_settings.dart';
// import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';
import 'package:healthonify_mobile/widgets/tab_app_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class CalorieDetailScreen extends StatefulWidget {
  final bool isWeekly;
  const CalorieDetailScreen({Key? key, this.isWeekly = false})
      : super(key: key);

  @override
  State<CalorieDetailScreen> createState() => _CalorieDetailScreenState();
}

class _CalorieDetailScreenState extends State<CalorieDetailScreen>
    with TickerProviderStateMixin {
  AllTrackers data = AllTrackers();
  int totalConsumedCalories = 0;
  int totalBurntCalories = 0;
  int baseGoal = 0;
  int remainingCals = 0;

  Future<void> getAllTrackers(
    BuildContext context,
  ) async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      data = await Provider.of<AllTrackersData>(context, listen: false)
          .getDiaryData(
              userId!, DateFormat("yyyy-MM-dd").format(DateTime.now()));
      totalConsumedCalories =
          double.parse(data.calorieProgress!["totalFoodCalories"] ?? "0")
              .round();
      baseGoal =
          double.parse(data.calorieProgress!["caloriesGoal"] ?? "0").round();

      print("baseGoal : $baseGoal");
      print("totalConsumedCalories : $totalConsumedCalories");

      remainingCals = baseGoal - totalConsumedCalories;
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error something went wrong $e");
      // Fluttertoast.showToast(msg: "Unable to fetch water intake data");
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      appBar: TabAppBar(
        appBarTitle: 'Calories & Macros',
        widgetRight: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const CalorieSettings();
              }));
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.grey,
              size: 26,
            ),
            splashRadius: 20,
          ),
        ),
        bottomWidget: ColoredBox(
          color: Theme.of(context).appBarTheme.backgroundColor!,
          child: customTabBar(context, tabController),
        ),
      ),
      body: FutureBuilder(
        future: getAllTrackers(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: DefaultTabController(
                      length: 2,
                      child: TabBarView(
                        controller: tabController,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          caloriesPage(data.calorieProgress!),
                          macrosPage(),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget caloriesPage(Map<String, dynamic> data) {
    List mealDetails = [
      {
        "title": "Breakfast",
        "percent": data["totalDietAnalysisData"] == null
            ? "0"
            : data["totalDietAnalysisData"]["dietPercentagesData"][0]
                ["percentage"],
        "calories": data["totalDietAnalysisData"] == null
            ? "0"
            : data["totalDietAnalysisData"]["dietPercentagesData"][0]
                    ["caloriesCount"]
                .toString(),
        "color": Colors.blue,
      },
      {
        "title": "Morning Snack",
        "percent": data["totalDietAnalysisData"] == null
            ? "0"
            : data["totalDietAnalysisData"]["dietPercentagesData"][1]
                ["percentage"],
        "calories": data["totalDietAnalysisData"] == null
            ? "0"
            : data["totalDietAnalysisData"]["dietPercentagesData"][1]
                    ["caloriesCount"]
                .toString(),
        "color": Colors.red,
      },
      {
        "title": "Lunch",
        "percent": data["totalDietAnalysisData"] == null
            ? "0"
            : data["totalDietAnalysisData"]["dietPercentagesData"][2]
                ["percentage"],
        "calories": data["totalDietAnalysisData"] == null
            ? "0"
            : data["totalDietAnalysisData"]["dietPercentagesData"][2]
                    ["caloriesCount"]
                .toString(),
        "color": Colors.purple,
      },
      {
        "title": "Afternoon Snack",
        "percent": data["totalDietAnalysisData"] == null
            ? "0"
            : data["totalDietAnalysisData"]["dietPercentagesData"][3]
                ["percentage"],
        "calories": data["totalDietAnalysisData"] == null
            ? "0"
            : data["totalDietAnalysisData"]["dietPercentagesData"][3]
                    ["caloriesCount"]
                .toString(),
        "color": Colors.orange,
      },
      {
        "title": "Dinner",
        "percent": data["totalDietAnalysisData"] == null
            ? "0"
            : data["totalDietAnalysisData"]["dietPercentagesData"][4]
                ["percentage"],
        "calories": data["totalDietAnalysisData"] == null
            ? "0"
            : data["totalDietAnalysisData"]["dietPercentagesData"][4]
                    ["caloriesCount"]
                .toString(),
        "color": Colors.indigo,
      }
    ];
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     IconButton(
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.chevron_left_rounded,
        //         size: 22,
        //         color: Theme.of(context).colorScheme.secondary,
        //       ),
        //       splashRadius: 18,
        //     ),
        //     Text(
        //       'Today',
        //       style: Theme.of(context).textTheme.labelMedium,
        //     ),
        //     IconButton(
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.chevron_right_rounded,
        //         size: 22,
        //         color: Theme.of(context).colorScheme.secondary,
        //       ),
        //       splashRadius: 18,
        //     ),
        //   ],
        // ),
        Card(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: CircularPercentIndicator(
                    radius: 100,
                    lineWidth: 14,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("$remainingCals kcal"),
                        const Text("Remaining")
                      ],
                    ),
                    percent: baseGoal == 0 ? 0 : remainingCals / baseGoal,
                    progressColor: Colors.blueGrey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      // mainAxisSpacing: 4,
                      crossAxisSpacing: 10,
                      // mainAxisExtent: ,
                      childAspectRatio: 1 / 0.5,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: mealDetails.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 10,
                                      width: 10,
                                      color: mealDetails[index]["color"],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 9,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          mealDetails[index]['title'],
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          mealDetails[index]['percent'] + ' %',
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "(${mealDetails[index]['calories']})",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(
                  color: Colors.grey[350],
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Calories'),
                      Text('${data["totalFoodCalories"]}'),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[350],
                  height: 20,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: const [
                //       Text('Net Calories'),
                //       Text('0'),
                //     ],
                //   ),
                // ),
                // Divider(
                //   color: Colors.grey[350],
                //   height: 20,
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Goal'),
                      Text(
                        "${data["caloriesGoal"]}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.blue[300]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget macrosPage() {
    return data.calorieProgress!['totalMacrosAnalysisData'] == null
        ? const Center(
            child: Text("No Data Available"),
          )
        : ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //         Icons.chevron_left_rounded,
              //         size: 22,
              //         color: Theme.of(context).colorScheme.secondary,
              //       ),
              //       splashRadius: 18,
              //     ),
              //     Text(
              //       'Today',
              //       style: Theme.of(context).textTheme.labelMedium,
              //     ),
              //     IconButton(
              //       onPressed: () {},
              //       icon: Icon(
              //         Icons.chevron_right_rounded,
              //         size: 22,
              //         color: Theme.of(context).colorScheme.secondary,
              //       ),
              //       splashRadius: 18,
              //     ),
              //   ],
              // ),
              Card(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: CircularPercentIndicator(
                          radius: 100,
                          lineWidth: 14,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("$remainingCals kcal"),
                              const Text("Remaining")
                            ],
                          ),
                          percent: baseGoal == 0 ? 0 : remainingCals / baseGoal,
                          progressColor: Colors.blueGrey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  const Text(''),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Container(
                                            height: 8,
                                            width: 8,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text('Carbohydrates'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Container(
                                            height: 8,
                                            width: 8,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text('Fat'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Container(
                                            height: 8,
                                            width: 8,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text('Protiens'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Container(
                                            height: 8,
                                            width: 8,
                                            color: Colors.purple,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text('Fibers'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Text(
                                    'Total',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                        '${data.calorieProgress!['totalMacrosAnalysisData']['carbs']} gms'),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                        '${data.calorieProgress!['totalMacrosAnalysisData']['fats']} gms'),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                        '${data.calorieProgress!['totalMacrosAnalysisData']['proteins']} gms'),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                        '${data.calorieProgress!['totalMacrosAnalysisData']['fiber']} gms'),
                                  ),
                                ],
                              ),
                            ),
                            // Expanded(
                            //   flex: 1,
                            //   child: Column(
                            //     children: [
                            //       Text(
                            //         'Goal',
                            //         style: Theme.of(context).textTheme.labelMedium,
                            //       ),
                            //       const SizedBox(height: 10),
                            //       Padding(
                            //         padding: const EdgeInsets.symmetric(vertical: 4),
                            //         child: Text(
                            //           '50%',
                            //           style: Theme.of(context)
                            //               .textTheme
                            //               .bodyMedium!
                            //               .copyWith(color: Colors.blue),
                            //         ),
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.symmetric(vertical: 4),
                            //         child: Text(
                            //           '50%',
                            //           style: Theme.of(context)
                            //               .textTheme
                            //               .bodyMedium!
                            //               .copyWith(color: Colors.blue),
                            //         ),
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.symmetric(vertical: 4),
                            //         child: Text(
                            //           '50%',
                            //           style: Theme.of(context)
                            //               .textTheme
                            //               .bodyMedium!
                            //               .copyWith(color: Colors.blue),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
  }

  TabBar customTabBar(context, TabController controller) => TabBar(
        controller: controller,
        // isScrollable: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Calories'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Macros',
            ),
          ),
        ],
        labelStyle: Theme.of(context).textTheme.labelMedium,
        indicatorColor: Colors.red,
        indicatorWeight: 2.5,
      );
}
