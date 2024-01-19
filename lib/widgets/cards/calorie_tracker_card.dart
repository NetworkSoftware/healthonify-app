import 'dart:developer';

import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/home_tracker_model/home_tracker_model.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/providers/tracker_data/home_tracker_data.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/func/trackers/step_tracker.dart';
import 'package:healthonify_mobile/func/trackers/steps_tracker_func.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/trackers/calorie_tracker_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/calories_details.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class CaloriesTrackerCard extends StatefulWidget {
  final int stepsGoal;

  const CaloriesTrackerCard({required this.stepsGoal, Key? key})
      : super(key: key);

  @override
  State<CaloriesTrackerCard> createState() => _CaloriesTrackerCardState();
}

class _CaloriesTrackerCardState extends State<CaloriesTrackerCard> {
  int totalConsumedCalories = 0;
  int totalBurntCalories = 0;
  int baseGoal = 0;
  int remainingCals = 0;
  int stepsCals = 0;
  HomeTrackerModel trackerData = HomeTrackerModel();

  Future<void> fetchHomeTrackerData() async {
    String userId =
    Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      trackerData =
      await Provider.of<HomeTrackerProvider>(context, listen: false)
          .getHomeTrackerData(userId);
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching tracker logs');
    }
  }
  Future<void> fetchWeightLogs() async {
    try {
      String userId =
          Provider.of<UserData>(context, listen: false).userData.id!;

      await Provider.of<CalorieTrackerProvider>(context, listen: false).getCalories(
          "?userId=$userId&date=${DateFormat("yyyy-MM-dd").format(DateTime.now())}");
    } on HttpException catch (e) {
      log('Error fetching calories data http $e');
    } catch (e) {
      log('Error fetching calories data $e');
    }
  }

  StepTrackerData stepsData = StepTrackerData();

  Future<void> getSteps(
      BuildContext context, int goal, VoidCallback onSuccess) async {
    try {
      DateTime startDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      stepsData = await StepTracker().initHealth(goal, startDate);

      print("stepDAtaaa : $stepsData");
      if (stepsData.stepCount != null) {
        log(stepsData.stepCount.runtimeType.toString());
        log("step data ${stepsData.stepCount}");
        onSuccess.call();
      } else {
        log("step data1");
      }
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get get top level expertise widget $e");
      // Fluttertoast.showToast(msg: "Unable to fetch water intake data");
    }
  }

  Future<void> getAllTrackers(
      BuildContext context, VoidCallback onSuccess) async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      await Provider.of<AllTrackersData>(context, listen: false)
          .getAllTrackers(userId!);

      SharedPrefManager prefManager = SharedPrefManager();
      bool test = await prefManager.getStepTrackerEnabled();
      if (test == true) {
        DateTime startDate = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        stepsData = await StepTracker().initHealth(1, startDate);
        if (stepsData.stepCount != null && stepsData.stepCount != "null") {
          onSuccess.call();
        }
      }
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
     // onLoadFail = true;
    } catch (e) {
      log("Error something went wrong $e");
    //  onLoadFail = true;

      // Fluttertoast.showToast(msg: "Unable to fetch water intake data");
    } finally {
     // flag = true;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHomeTrackerData();
    getSteps(
      context,
      widget.stepsGoal,
      () => StepsTrackerFunc().updateSteps(
          context,
          stepsData.stepsData!,
          () => Provider.of<AllTrackersData>(context, listen: false)
              .localUpdateSteps(int.parse(stepsData.stepCount!))),
    );
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchWeightLogs(),
      builder: (context, snapshot) =>
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Consumer<CalorieTrackerProvider>(
                builder: (context, value, child) {

                  totalBurntCalories =
                      double.parse(value.calorieData.totalBurntCalories ?? "0")
                          .round();
                  print("total burnt ${value.calorieData.totalBurntCalories}");

                  if(trackerData.calorieProgress != null){
                    totalConsumedCalories = trackerData.calorieProgress!.totalDietAnalysisData!.totalCalories!.round();
                    print("totalConsumedCalories : $totalConsumedCalories");
                  }


                  baseGoal = double.parse(
                      value.calorieData.caloriesConsumptionGoal ?? "0")
                      .round();

                  stepsCals = double.parse(
                      value.calorieData.stepsCalorie ?? "0")
                      .round();

                  print("baseGoal : $baseGoal");

                  remainingCals = baseGoal +
                      (totalConsumedCalories - totalBurntCalories - stepsCals);
                  log("remaining calories = $remainingCals and base goal = $baseGoal");
                  log("percentage = ${remainingCals / baseGoal}");
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(
                            context, /*rootnavigator: true*/
                          ).push(MaterialPageRoute(builder: (context) {
                            return const CalorieDetailScreen();
                          }));
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                color: orange,
                                borderRadius: BorderRadius
                                    .only(
                                    topLeft: Radius.circular(10),
                                    topRight:
                                    Radius.circular(10)),
                              ),
                              child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CALORIES',
                                    style: Theme.of(context).textTheme.labelLarge!.copyWith(color: whiteColor,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Remaining = Goal + Food - Exercise - Steps',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        CircularPercentIndicator(
                                          radius: 70,
                                          animation: true,
                                          animationDuration: 2000,
                                          progressColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          backgroundColor: Colors.grey[200]!,
                                          lineWidth: 12,
                                          percent: baseGoal == 0
                                              ? 0
                                              : remainingCals.isNegative
                                              ? 1
                                              : remainingCals > baseGoal
                                              ? 1
                                              : remainingCals / baseGoal,
                                          circularStrokeCap:
                                          CircularStrokeCap.round,
                                          center: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                remainingCals.isNegative
                                                    ? "${remainingCals.abs()}"
                                                    : "$remainingCals",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall,
                                              ),
                                              Text(
                                                remainingCals.isNegative
                                                    ? 'Exceeded'
                                                    : 'Remaining',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
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
                                          categories(
                                            context,
                                            'Base Goal',
                                            "$baseGoal kcal",
                                            Image.asset(
                                              'assets/icons/goal.png',
                                              height: 24,
                                              width: 24,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          const Divider(thickness: 2),
                                          const SizedBox(height: 3),
                                          categories(
                                            context,
                                            'Food',
                                            "$totalConsumedCalories kcal",
                                            Image.asset(
                                              'assets/icons/food.png',
                                              height: 24,
                                              width: 24,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          const Divider(thickness: 2),
                                          const SizedBox(height: 3),
                                          categories(
                                            context,
                                            'Exercise',
                                            "$totalBurntCalories kcal",
                                            Image.asset(
                                              'assets/icons/fire.png',
                                              height: 24,
                                              width: 24,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          const Divider(thickness: 2),
                                          const SizedBox(height: 3),
                                          Consumer<AllTrackersData>(builder: (context, data, child) {
                                            Map<String, dynamic> trackerData = {};
                                            Future.delayed(const Duration(seconds: 2)).then((value) {
                                              trackerData = setData(snapshot, data);
                                            });

                                            return categories(
                                              context,
                                              'Steps',
                                              "${stepsCals.toStringAsFixed(0)} Kcal",
                                              Image.asset(
                                                'assets/icons/walk.png',
                                                height: 24,
                                                width: 24,
                                              ),
                                            );
                                          }),

                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ))
         ,
    );
  }

  Map<String, dynamic> setData(AsyncSnapshot snapshot, AllTrackersData data) {
    int waterGoal = 0, glasses = 0;
    String totalSleepGoal = "0h", goalSleep = "0h";
    double waterPercentage = 0.0, sleepPercentage = 0.0, stepsPercentage = 0;
    String totalStepsGoal = "", stepsCount = "";

    if (snapshot.connectionState == ConnectionState.waiting) {
      waterGoal = glasses = 0;
      waterPercentage = sleepPercentage = 0;
    }
    else {
      //set water data
      waterGoal = data.allTrackersData.totalWaterGoal ?? 0;
      glasses = data.allTrackersData.userWaterGlassCount ?? 0;
      waterPercentage = glasses == 0
          ? 0
          : glasses > waterGoal
          ? 1
          : glasses / waterGoal;

      totalStepsGoal = data.allTrackersData.totalStepsGoal!.toString();
      stepsCount = data.allTrackersData.userStepsCount!.toString();

      stepsPercentage = data.allTrackersData.userStepsCount == 0
          ? 0
          : data.allTrackersData.userStepsCount! >
          data.allTrackersData.totalStepsGoal!
          ? 1
          : data.allTrackersData.userStepsCount! /
          data.allTrackersData.totalStepsGoal!;

      // log("steps percentage " + stepsPercentage.toString());

      //set sleep data

      int totalSleepHrs = (data.allTrackersData.totalSleepGoal! ~/ 3600);
      int totalSleepMins =
      (data.allTrackersData.totalSleepGoal!.remainder(3600) ~/ 60);
      if (totalSleepMins != 0 && totalSleepHrs != 0) {
        totalSleepGoal = "${totalSleepHrs}h ${totalSleepMins}m";
      } else if (totalSleepMins != 0 && totalSleepHrs == 0) {
        totalSleepGoal = "$totalSleepMins m";
      } else {
        totalSleepGoal = "$totalSleepHrs h";
      }

      // log(totalSleepMins.toString());

      int goalSleepMins =
          data.allTrackersData.userSleepCount!.remainder(3600) ~/ 60;
      int goalSleepHrs = data.allTrackersData.userSleepCount! ~/ 3600;

      if (goalSleepMins != 0 && goalSleepHrs != 0) {
        goalSleep = "${goalSleepHrs}h ${goalSleepMins}m";
      } else if (goalSleepMins != 0 && goalSleepHrs == 0) {
        goalSleep = "$goalSleepMins m";
      } else {
        goalSleep = "${goalSleepHrs}h";
      }

      sleepPercentage = data.allTrackersData.userSleepCount == 0
          ? 0
          : data.allTrackersData.userSleepCount! >
          data.allTrackersData.totalSleepGoal!
          ? 1
          : data.allTrackersData.userSleepCount! /
          data.allTrackersData.totalSleepGoal!;
      // log("sleep " + sleepPercentage.toString());
      // setState(() {});
    }

    return {
      "watergoal": waterGoal.toString(),
      "glasses": glasses.toString(),
      "waterPercentage": waterPercentage,
      "sleepGoal": totalSleepGoal,
      "userSleepCount": goalSleep,
      "sleepPercentage": sleepPercentage,
      "totalStepsGoal": totalStepsGoal,
      "stepsCount": stepsCount,
      "stepsPercentage": stepsPercentage,
    };
  }

  String stepsToCal(String steps) {
    double cal = double.parse((int.parse(steps) * 0.04).toStringAsFixed(2));
    return "${cal.toString()} Kcal";
  }

  String stepsToCalConsumption(String steps) {
    double cal = double.parse((int.parse(steps) * 0.04).toStringAsFixed(2));
    return cal.toString();
  }

  Widget categories(
    context,
    String? title,
    String? subTitle,
    Widget? icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon!,
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              subTitle!,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
