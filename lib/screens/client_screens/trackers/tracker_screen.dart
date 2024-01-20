import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/home_tracker_model/home_tracker_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/tracker_data/home_tracker_data.dart';
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
import 'package:provider/provider.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({Key? key}) : super(key: key);

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  HomeTrackerModel trackerData = HomeTrackerModel();

  String? calories;
  String? steps;
  String? water;
  String? sleep;
  String? bloodPressure;
  String? bloodGlucose;
  String? hba1c;
  String? bmr;
  String? bmi;

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

  late String userId;

  String? sleepInHours;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
  }

  @override
  Widget build(BuildContext context) {
    // calories = trackerData.calorieProgress!.totalFoodCalories;
    // steps = trackerData.stepsProgress!.userStepsCount;
    // sleep = trackerData.sleepProgress!.userSleepCount;
    // water = trackerData.waterProgress!.userWaterGlassCount;
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
      body: FutureBuilder(
        future: fetchHomeTrackerData(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      const SizedBox(height: 8),
                      otherCards(
                        context,
                        'Diet/Nutrition',
                        'Calories consumed in the last 24h',
                        trackerData.calorieProgress == null
                            ? "0"
                            : trackerData.calorieProgress!.totalFoodCalories!,
                        'Add food',
                        () {
                          Navigator.of(
                            context, /*rootnavigator: true*/
                          ).push(MaterialPageRoute(builder: (context) {
                            return const MealPlansScreen();
                          }));
                        },
                      ),
                      // exerciseCard(context),
                      otherCards(
                        context,
                        'Steps',
                        'No. of steps walked the previous day',
                        trackerData.stepsProgress == null
                            ? "0"
                            : trackerData.stepsProgress!.userStepsCount!,
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
                        'Quantity of water consumed in mL',
                        trackerData.waterProgress == null
                            ? "0"
                            : trackerData.waterProgress!.userWaterGlassCount!,
                        'Add Water',
                        () {
                          Navigator.of(
                            context, /*rootnavigator: true*/
                          ).push(MaterialPageRoute(builder: (context) {
                            return const WaterTrackerScreen();
                          }));
                        },
                      ),
                      otherCards(
                        context,
                        'Sleep',
                        'No. of hours slept previous night',
                        trackerData.sleepProgress == null ? "0" : sleepInHours!,
                        // : trackerData.sleepProgress!.userSleepCount!,
                        'Add Sleep',
                        () {
                          Navigator.of(
                            context, /*rootnavigator: true*/
                          ).push(MaterialPageRoute(builder: (context) {
                            return const SleepScreen();
                          }));
                        },
                      ),
                      otherCards(
                        context,
                        'Blood Pressure',
                        'Latest blood pressure reading',
                        trackerData.bloodPressureLogs == null ||
                                trackerData.bloodPressureLogs!.isEmpty
                            ? 'No data available'
                            : "${trackerData.bloodPressureLogs![0].systolic!}/${trackerData.bloodPressureLogs![0].diastolic}",
                        'Add BP reading',
                        () {
                          Navigator.of(
                            context, /*rootnavigator: true*/
                          ).push(MaterialPageRoute(builder: (context) {
                            return const BloodPressureScreen();
                          }));
                        },
                      ),
                      otherCards(
                        context,
                        'Blood Glucose',
                        'Latest glucose reading',
                        trackerData.bloodGlucoseLogs == null ||
                                trackerData.bloodGlucoseLogs!.isEmpty
                            ? 'No data available'
                            : "${trackerData.bloodGlucoseLogs![0].bloodGlucoseLevel}",
                        'Add Glucose reading',
                        () {
                          Navigator.of(
                            context, /*rootnavigator: true*/
                          ).push(MaterialPageRoute(builder: (context) {
                            return const BloodGlucoseScreen();
                          }));
                        },
                      ),
                      otherCards(
                        context,
                        'Hb1Ac',
                        'Latest heamoglobin content reading',
                        trackerData.hba1CLogs == null ||
                                trackerData.hba1CLogs!.isEmpty
                            ? 'No data available'
                            : "${trackerData.hba1CLogs![0].hba1CLevel}",
                        'Add Hb1Ac reading',
                        () {
                          Navigator.of(
                            context, /*rootnavigator: true*/
                          ).push(MaterialPageRoute(builder: (context) {
                            return const HbA1cScreen();
                          }));
                        },
                      ),
                      otherCards(
                        context,
                        'BMR',
                        'Latest BMR reading',
                        '123',
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
                        '123',
                        'Calculate BMI',
                        () {
                          Navigator.of(
                            context, /*rootnavigator: true*/
                          ).push(MaterialPageRoute(builder: (context) {
                            return  BmiDetailsScreen();
                          }));
                        },
                      ),
                      otherCards(
                        context,
                        'Calorie Intake',
                        'Latest reading',
                        '-',
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
                        '-',
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
                        '-',
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
                        '-',
                        'Calculate Lean Body Mass',
                        () {
                          Navigator.of(
                            context, /*rootnavigator: true*/
                          ).push(MaterialPageRoute(builder: (context) {
                            return const LeanBodyMassScreen();
                          }));
                        },
                      ),
                      otherCards(
                        context,
                        'Macro Calculator',
                        'Latest reading',
                        '-',
                        'Calculate Macros',
                        () {
                          Navigator.of(
                            context, /*rootnavigator: true*/
                          ).push(MaterialPageRoute(builder: (context) {
                            return const MacrosCalculatorScreen();
                          }));
                        },
                      ),
                      otherCards(
                        context,
                        'RMR',
                        'Latest reading',
                        '-',
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
                );
        },
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
