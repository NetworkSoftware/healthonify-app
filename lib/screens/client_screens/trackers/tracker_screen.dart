import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/all_trackers.dart';
import 'package:healthonify_mobile/models/home_tracker_model/home_tracker_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/tracker_data/home_tracker_data.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/trackers/calorie_tracker_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/bmi_details.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/bmr_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/body_fat_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/ideal_weight_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/lean_body_mass.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/macros_calc.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/rmr_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/set_calories_target.dart';
import 'package:healthonify_mobile/screens/client_screens/health_meter/blood_pressure/blood_pressure_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/sleep/sleep_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/step_tracker/steps_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/vitals_screens/hba1c_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/vitals_screens/blood_glucose_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/watertracker/water_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/meal_plans_screen.dart';
import 'package:healthonify_mobile/screens/my_diary/exercises/cardio_strength_screen.dart';
import 'package:healthonify_mobile/screens/my_diary/workout_routines.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({Key? key}) : super(key: key);

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  HomeTrackerModel trackerData = HomeTrackerModel();
  AllTrackers data = AllTrackers();
  String? calories;
  String? steps;
  String? water;
  String? sleep;
  String? bloodPressure;
  String? bloodGlucose;
  String? hba1c;
  String? bmr;
  String? bmi;
  bool isLoading = true;

  late String userId;
  dynamic fastingRecord,
      randomRecord,
      bmiData,
      rmrData,
      bfpData,
      calorieIntakeData,
      idealWeightData,
      lbmData,
      macroCalculatorData,bmrData;
  String? sleepInHours;

  Future<void> fetchHomeTrackerData() async {
    try {
      trackerData =
          await Provider.of<HomeTrackerProvider>(context, listen: false)
              .getHomeTrackerData(userId);

      int temp = int.parse(trackerData.sleepProgress!.userSleepCount!);
      double hours = temp / 3600;
      sleepInHours = hours.toString();
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching tracker logs');
    }
  }

  Future<void> getAllTrackers() async {
    try {
      data = await Provider.of<AllTrackersData>(context, listen: false)
          .getDiaryData(
              userId, DateFormat("yyyy-MM-dd").format(DateTime.now()));
      updateCaloriesTracker(
          double.parse(data.calorieProgress!['totalWorkoutCalories']));

      if (data.fitnessToolsData!.isNotEmpty) {
        if (data.fitnessToolsData!['bmr'].isNotEmpty) {
          bmrData = data.fitnessToolsData!['bmr'];
        }
        if (data.fitnessToolsData!['bmi'].isNotEmpty) {
          bmiData = data.fitnessToolsData!['bmi'];
        }
        if (data.fitnessToolsData!['lbm'].isNotEmpty) {
          lbmData = data.fitnessToolsData!['lbm'];
        }
        if (data.fitnessToolsData!['idealWeight'].isNotEmpty) {
          idealWeightData = data.fitnessToolsData!['idealWeight'];
        }
        if (data.fitnessToolsData!['rmr'].isNotEmpty) {
          rmrData = data.fitnessToolsData!['rmr'];
        }
        if (data.fitnessToolsData!['calorieIntake'].isNotEmpty) {
          calorieIntakeData = data.fitnessToolsData!['calorieIntake'];
        }
        if (data.fitnessToolsData!['bfp'].isNotEmpty) {
          bfpData = data.fitnessToolsData!['bfp'];
        }
      }

      print("BFP DATA : $bfpData");

      if (data.bloodGlucoseLogs!.isNotEmpty) {
        fastingRecord = data.bloodGlucoseLogs!
            .firstWhere((element) => element["testType"] == "fasting");
        randomRecord = data.bloodGlucoseLogs!
            .firstWhere((element) => element["testType"] == "random");
      }


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

  void updateCaloriesTracker(double value) {
    Future.delayed(
        Duration.zero,
        () => Provider.of<CalorieTrackerProvider>(context, listen: false)
            .updateCaloriesTrackerExercise(value.toString()));
  }

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    getAllTrackers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tracker",
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: whiteColor),
        ),
        shadowColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  const SizedBox(height: 8),
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
                        getAllTrackers();
                      }
                    },
                  ),
                  otherCards(
                    context,
                    'Steps',
                    'No. of steps walked the previous day',
                    '${data.userStepsCount!}',
                    'Add Steps',
                    () {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return const StepsScreen();
                      }));
                    },
                  ),
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
                        getAllTrackers();
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
                        getAllTrackers();
                      }
                    },
                  ),
                  otherSecondaryCards(
                    context,
                    'Blood Glucose',
                    'Latest glucose reading(Fasting)',
                    '${fastingRecord == null ? "0" : fastingRecord["bloodGlucoseLevel"]}',
                    'Latest glucose reading(Random)',
                    '${randomRecord == null ? "0" : randomRecord["bloodGlucoseLevel"]}',
                    'Add Glucose reading',
                    () async {
                      bool result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const BloodGlucoseScreen();
                      }));

                      if (result == true) {
                        getAllTrackers();
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
                        getAllTrackers();
                      }
                    },
                  ),
                  // exerciseCard(context),

                  otherCards(
                    context,
                    'BMR',
                    'Latest BMR reading',
                    '${bmrData == null ? "0" : bmrData["data"]["bmr"]}',
                    'Calculate BMR',
                    () {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return const BMRScreen();
                      }));
                    },
                  ),
                  otherCards(
                    context,
                    'BMI',
                    'Latest BMI reading',
                    '${bmiData == null ? "0" : bmiData["data"]["bmi"]}',
                    'Calculate BMI',
                    () {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return BmiDetailsScreen();
                      }));
                    },
                  ),
                  otherCards(
                    context,
                    'Calorie Intake',
                    'Latest reading',
                    '${calorieIntakeData == null ? "0" : calorieIntakeData["data"]["calorieCount"]}',
                    'Set Calorie Intake',
                    () {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return const SetCaloriesTarget();
                      }));
                    },
                  ),
                  otherCards(
                    context,
                    'Ideal Weight',
                    'Latest reading',
                    '${idealWeightData == null ? "0" : idealWeightData["data"]["idealWeight"]}',
                    'Calculate Ideal Weight',
                    () {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return const IdealWeightScreen();
                      }));
                    },
                  ),
                  otherCards(
                    context,
                    'Body Fat',
                    'Latest reading',
                    '${bfpData == null ? "0" : bfpData["data"]["bfp"]}',
                    'Calculate Body Fat',
                    () {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return const BodyFatScreen();
                      }));
                    },
                  ),
                  otherCards(
                    context,
                    'Lean Body Mass',
                    'Latest reading',
                    '${lbmData == null ? "0" : lbmData["data"]["lbm"]}',
                    'Calculate Lean Body Mass',
                    () {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return const LeanBodyMassScreen();
                      }));
                    },
                  ),
                  // otherCards(
                  //   context,
                  //   'Macro Calculator',
                  //   'Latest reading',
                  //   '${macroCalculatorData == null ? "0" : macroCalculatorData["data"]["lbm"]}',
                  //   'Calculate Macros',
                  //   () {
                  //     Navigator.of(
                  //       context, /*rootnavigator: true*/
                  //     ).push(MaterialPageRoute(builder: (context) {
                  //       return const MacrosCalculatorScreen();
                  //     }));
                  //   },
                  // ),
                  otherCards(
                    context,
                    'RMR',
                    'Latest reading',
                    '${rmrData == null ? "0" : rmrData["data"]["rmr"]}',
                    'Calculate RMR',
                    () {
                      Navigator.of(
                        context, /*rootnavigator: true*/
                      ).push(MaterialPageRoute(builder: (context) {
                        return const RMRscreen();
                      }));
                    },
                  ),
                ],
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
                Text(
                  desc,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  qty,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Divider(),
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

  Widget otherSecondaryCards(
    context,
    String cardTitle,
    String desc1,
    String qty1,
    String desc2,
    String qty2,
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
                    desc1,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Text(
                  qty1,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    desc2,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Text(
                  qty2,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Divider(),
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
                Text(
                  '144',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exercise title and description',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '90',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.directions_walk_rounded,
                    size: 30,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connect a step tracker',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      'Automatically tracks steps and calories burned',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
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
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const CardioStrengthScreen(screenName: 'Cardio');
          }));
        },
      },
      {
        'title': 'Strength',
        'route': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const CardioStrengthScreen(screenName: 'Strength');
          }));
        },
      },
      {
        'title': 'Workout Routines',
        'route': () {
          Navigator.of(
            context, /*rootnavigator: true*/
          ).push(MaterialPageRoute(builder: (context) {
            return const WorkoutRoutinesScreen();
          }));
        },
      },
    ];
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.all(10),
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
                        color: whiteColor.withOpacity(0.5),
                        child: InkWell(
                          onTap: popUpOptions[index]['route'],
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
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.edit_outlined,
            size: 28,
            color: Theme.of(context).colorScheme.secondary,
          ),
          splashRadius: 20,
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.pie_chart_outline_rounded,
            size: 28,
            color: Theme.of(context).colorScheme.secondary,
          ),
          splashRadius: 20,
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.more_vert_rounded,
            size: 28,
            color: Theme.of(context).colorScheme.secondary,
          ),
          splashRadius: 20,
        ),
      ],
    );
  }
}
