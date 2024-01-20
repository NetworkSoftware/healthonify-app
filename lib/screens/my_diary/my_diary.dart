import 'dart:developer';
import 'package:healthonify_mobile/main.dart';
import 'package:healthonify_mobile/providers/trackers/calorie_tracker_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/all_trackers.dart';
import 'package:healthonify_mobile/models/exercise/exercise_log_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/exercises/exercises_data.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/health_meter/blood_pressure/blood_pressure_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/sleep/sleep_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/vitals_screens/hba1c_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/vitals_screens/blood_glucose_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/watertracker/water_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/meal_plans_screen.dart';
import 'package:healthonify_mobile/screens/my_diary/exercises/cardio_strength_screen.dart';
import 'package:healthonify_mobile/screens/my_diary/diary_settings.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/calendar_appbar.dart';
import 'package:provider/provider.dart';

enum PopUp { complete, settings }

class MyDiary extends StatefulWidget {
  final bool isFromClient;
  final String clientId;

  const MyDiary({Key? key, this.isFromClient = false, this.clientId = ""})
      : super(key: key);

  @override
  State<MyDiary> createState() => _MyDiaryState();
}

class _MyDiaryState extends State<MyDiary> {
  AllTrackers data = AllTrackers();
  List<ExerciseLogList> exerciseLogList = [];
  late String selectedDate;

  bool isLoading = true;

  late String userId;

  Future<void> getAllTrackers(BuildContext context) async {
    try {
      if (widget.isFromClient == true) {
        data = await Provider.of<AllTrackersData>(context, listen: false)
            .getDiaryData(
          widget.clientId,
          DateFormat("yyyy-MM-dd").format(DateTime.now()),
        );

        updateCaloriesTracker(
            double.parse(data.calorieProgress!['totalWorkoutCalories']));
      } else {
        data = await Provider.of<AllTrackersData>(context, listen: false)
            .getDiaryData(
                userId, DateFormat("yyyy-MM-dd").format(DateTime.now()));
        updateCaloriesTracker(
            double.parse(data.calorieProgress!['totalWorkoutCalories']));
      }

      //double hours = data.userSleepCount! / 3600;

      int totalSleepHrs = (data.userSleepCount! ~/ 3600);
      int totalSleepMins = (data.userSleepCount!.remainder(3600) ~/ 60);
      if (totalSleepMins != 0 && totalSleepHrs != 0) {
        sleepInHours = "${totalSleepHrs}h ${totalSleepMins}m";
      } else if (totalSleepMins != 0 && totalSleepHrs == 0) {
        sleepInHours = "$totalSleepMins m";
      } else {
        sleepInHours = "$totalSleepHrs h";
      }

      // sleepInHours = hours.toString();
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error something went wrong1112 $e");
      // Fluttertoast.showToast(msg: "Unable to fetch water intake data");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  bool isRefresh = false;

  Future<void> getTrackerDataByDate(BuildContext context, String date) async {
    setState(() {
      isRefresh = true;
    });
    try {
      data = await Provider.of<AllTrackersData>(context, listen: false)
          .getDiaryData(
        userId,
        DateFormat('yyyy-MM-dd').format(DateFormat('yyyy/MM/dd').parse(date)),
      );

      double hours = data.userSleepCount! / 3600;
      sleepInHours = hours.toString();
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log("Error something went wrong11 $e");
    } finally {
      setState(() {
        isRefresh = false;
      });
    }
  }

  void updateCaloriesTracker(double value) {
    Future.delayed(
        Duration.zero,
        () => Provider.of<CalorieTrackerProvider>(context, listen: false)
            .updateCaloriesTrackerExercise(value.toString()));
  }

  Future<void> getExerciseLogs(String date) async {
    exerciseLogList = [];
    getAllTrackers(context);

    try {
      exerciseLogList =
          await Provider.of<ExercisesData>(context, listen: false).getExLogs(
        "userId=$userId&date=$date",
      );
      if (mounted) {
        setState(() {});
      }
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log("Error something went wrong $e");
    } finally {}
  }

  String? sleepInHours;

  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat("yyyy/MM/dd").format(DateTime.now());

    userId = Provider.of<UserData>(context, listen: false).userData.id!;

    getAllTrackers(context);
    getExerciseLogs(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: 'Diary',
        widgetRight:
            widget.isFromClient ? const SizedBox() : appBarIcons(context),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<AllTrackersData>(
              builder: (context, value, child) => SafeArea(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: HorizCalendar(
                        function: (date) async {
                          selectedDate = date;
                          getTrackerDataByDate(context, date);
                          getExerciseLogs(date);
                        },
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      indent: 10,
                      endIndent: 10,
                    ),
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
                    isRefresh
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Calories Remaining',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge,
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.more_horiz_rounded,
                                            size: 22,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          splashRadius: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 7,
                                            child: Column(
                                              children: [
                                                Text(
                                                  data.calorieProgress![
                                                              'caloriesGoal'] ==
                                                          null
                                                      ? "0"
                                                      : '${data.calorieProgress!['caloriesGoal']}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium,
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Goal',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            )),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            '+',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Column(
                                            children: [
                                              Text(
                                                data.calorieProgress![
                                                                'totalDietAnalysisData']
                                                            ['totalCalories'] ==
                                                        null
                                                    ? "0"
                                                    : '${data.calorieProgress!['totalDietAnalysisData']['totalCalories']}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Food',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            '-',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Column(
                                            children: [
                                              Text(
                                                data.calorieProgress![
                                                            'totalWorkoutCalories'] ==
                                                        null
                                                    ? "0"
                                                    : '${data.calorieProgress!['totalWorkoutCalories']}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Exercise',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            '-',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Column(
                                            children: [
                                              Text(
                                                data.calorieProgress![
                                                            'totalStepsCaloriesBurnt'] ==
                                                        null
                                                    ? "0"
                                                    : '${data.calorieProgress!['totalStepsCaloriesBurnt']}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Steps',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            '=',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Column(
                                            children: [
                                              Text(
                                                data.calorieProgress![
                                                            'remainingCalories'] ==
                                                        null
                                                    ? "0"
                                                    : double.parse(data
                                                                .calorieProgress![
                                                            'remainingCalories'])
                                                        .ceil()
                                                        .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Remaining',
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
                                ],
                              ),
                              otherCards(
                                context,
                                'Diet/Nutrition',
                                'Calories consumed today',
                                '${data.calorieProgress!['totalDietAnalysisData']['totalCalories']} cal',
                                'Add food',
                                () async {
                                  bool result = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const MealPlansScreen();
                                  }));

                                  if (result == true) {
                                    getAllTrackers(context);
                                  }
                                },
                              ),
                              exerciseCard(context),
                              otherCards(
                                context,
                                'Water',
                                'Glasses of water consumed (one glass = 250ml) ',
                                '${data.userWaterGlassCount}',
                                'Add Water',
                                () async {
                                  bool result = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const WaterTrackerScreen();
                                  }));

                                  if (result == true) {
                                    getAllTrackers(context);
                                  }
                                },
                              ),
                              otherCards(
                                context,
                                'Sleep',
                                'No. of hours slept previous night',
                                '$sleepInHours',
                                // '${data.userSleepCount}',
                                'Add Sleep',
                                () async {
                                  bool result = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const SleepScreen();
                                  }));
                                  if (result == true) {
                                    getAllTrackers(context);
                                  }
                                },
                              ),
                              otherCards(
                                context,
                                'Blood Pressure',
                                'Latest blood pressure reading',
                                '${data.bloodPressureLogs!.isEmpty ? "0" : data.bloodPressureLogs![0]["systolic"]} /  ${data.bloodPressureLogs!.isEmpty ? "0" : data.bloodPressureLogs![0]["diastolic"]}',
                                'Add BP reading',
                                () async {
                                  bool result = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const BloodPressureScreen();
                                  }));

                                  if (result == true) {
                                    getAllTrackers(context);
                                  }
                                },
                              ),
                              otherCards(
                                context,
                                'Blood Glucose',
                                'Latest glucose reading',
                                '${data.bloodGlucoseLogs!.isEmpty ? "0" : data.bloodGlucoseLogs![0]["bloodGlucoseLevel"]}',
                                'Add Glucose reading',
                                () async {
                                  bool result = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const BloodGlucoseScreen();
                                  }));

                                  if (result == true) {
                                    getAllTrackers(context);
                                  }
                                },
                              ),
                              otherCards(
                                context,
                                'HbA1c',
                                'Latest heamoglobin content reading',
                                '${data.hba1cLogs!.isEmpty ? "0" : data.hba1cLogs![0]["hba1cLevel"]}',
                                'Add HbA1c reading',
                                () async {
                                  bool result = await Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const HbA1cScreen();
                                  }));

                                  if (result == true) {
                                    getAllTrackers(context);
                                  }
                                },
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget otherCards(
    context,
    String cardTitle,
    String desc,
    String qty,
    String button,
    Function onTap,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardTitle,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    desc,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Text(
                  qty,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Divider(),
            if (!widget.isFromClient &&
                preferences.getString("role") != "ROLE_EXPERT")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      onTap();
                    },
                    child: Text(
                      button,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      size: 22,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    splashRadius: 18,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget exerciseCard(context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exercise',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                // Text(
                //   '144',
                //   style: Theme.of(context).textTheme.labelMedium,
                // ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Calories Burnt Today",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  data.calorieProgress!['totalWorkoutCalories'] == null
                      ? "0"
                      : '${data.calorieProgress!['totalWorkoutCalories']} cal',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),

            // const Divider(),
            // if (!widget.isFromClient)
            //   Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.all(10),
            //         child: Icon(
            //           Icons.directions_walk_rounded,
            //           size: 30,
            //           color: Theme.of(context).colorScheme.secondary,
            //         ),
            //       ),
            //     ],
            //   ),
            const Divider(),
            if (!widget.isFromClient &&
                preferences.getString("role") != "ROLE_EXPERT")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showPopUp(context);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) {
                      //   return const ExercisesScreen();
                      // }));
                    },
                    child: const Text(
                      'Add Exercise',
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_horiz_rounded,
                      size: 22,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    splashRadius: 18,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void showPopUp(context) {
    List popUpOptions = [
      {
        'title': 'Cardiovascular',
        'route': () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const CardioStrengthScreen(
              screenName: 'Cardiovascular',
            );
          })).then((value) => getExerciseLogs(selectedDate));
        },
      },
      {
        'title': 'Strength',
        'route': () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const CardioStrengthScreen(
              screenName: 'Strength',
            );
          })).then((value) => getExerciseLogs(selectedDate));
        },
      },
      {
        'title': 'General Activity',
        'route': () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const CardioStrengthScreen(
              screenName: 'General Activity',
            );
          })).then((value) => getExerciseLogs(selectedDate));
        },
      },
      // {
      //   'title': 'Workout Routines',
      //   'route': () {
      //     Navigator.pop(context);
      //     Navigator.push(context, MaterialPageRoute(builder: (context) {
      //       return const WorkoutRoutinesScreen();
      //     }));
      //   },
      // },
    ];
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6, bottom: 6),
                  child: Text(
                    'Exercises',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: popUpOptions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Card(
                        color: Theme.of(context).canvasColor,
                        child: InkWell(
                          onTap: popUpOptions[index]['route'],
                          // Navigator.pop(context);
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(popUpOptions[index]['title']),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget appBarIcons(context) {
    return Row(
      children: [
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.edit_outlined,
        //     size: 28,
        //     color: Theme.of(context).colorScheme.onBackground,
        //   ),
        //   splashRadius: 20,
        // ),
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.pie_chart_outline_rounded,
        //     size: 28,
        //     color: Theme.of(context).colorScheme.onBackground,
        //   ),
        //   splashRadius: 20,
        // ),
        PopupMenuButton(
          icon: Icon(
            Icons.more_vert_rounded,
            size: 28,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          color: Theme.of(context).canvasColor,
          splashRadius: 20,
          itemBuilder: (context) {
            return [
              // PopupMenuItem(
              //   value: PopUp.complete,
              //   child: Text(
              //     'Complete Diary',
              //     style: Theme.of(context).textTheme.bodyMedium,
              //   ),
              // ),
              PopupMenuItem(
                value: PopUp.settings,
                child: Text(
                  'Diary Settings',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ];
          },
          onSelected: (value) {
            if (value == PopUp.complete) {
              Navigator.pop(context);
            } else if (value == PopUp.settings) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const DiarySettingsScreen();
              }));
            }
          },
        ),
      ],
    );
  }
}
