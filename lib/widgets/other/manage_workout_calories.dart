import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/goals_model.dart';
import 'package:healthonify_mobile/providers/trackers/calorie_tracker_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/weight_goal/weight_goal_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/workout_analysis/workout_analysis.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class ManageWorkoutCalories extends StatefulWidget {
  const ManageWorkoutCalories({Key? key}) : super(key: key);

  @override
  State<ManageWorkoutCalories> createState() => _ManageWorkoutCaloriesState();
}

class _ManageWorkoutCaloriesState extends State<ManageWorkoutCalories> {
  late String userId;
  int totalConsumedCalories = 0;
  int totalBurntCalories = 0;
  int baseGoal = 0;
  int burnGoal = 0;
  List<WeightGoalModel> goalData = [];

  Future<void> getWeightGoal() async {
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      goalData = await Provider.of<WeightGoalProvider>(context, listen: false)
          .getWeightGoals(userId);

      if (goalData.isNotEmpty) {
        burnGoal = int.parse(goalData[0].goalCalories!);
      }

      setState(() {});
      log('fetched weight goals');
    } on HttpException catch (e) {
      log('HTTP Exception: $e');
    } catch (e) {
      log("Error getting weight goals: $e");
    } finally {
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  @override
  void initState() {
    super.initState();
    getWeightGoal();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalorieTrackerProvider>(
      builder: (context, value, child) {
        totalBurntCalories =
            double.parse(value.calorieData.totalBurntCalories ?? "0").round();
        totalConsumedCalories =
            double.parse(value.calorieData.totalConsumedCalories ?? "0")
                .round();
        baseGoal =
            double.parse(value.calorieData.caloriesConsumptionGoal ?? "0")
                .round();
        // burnGoal =
        //     double.parse(value.calorieData.caloriesBurntGoal ?? "0").round();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Card(
            elevation: 0,
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(13),
            // ),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const WorkoutAnalysisScreen();
                }));
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Burnt',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              Text(
                                '$totalBurntCalories Cal',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              Text(
                                'out of $burnGoal Cal',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                        CircularPercentIndicator(
                          radius: 50,
                          animation: true,
                          animationDuration: 2000,
                          progressColor: const Color(0xFFff7f3f),
                          backgroundColor: Colors.white,
                          center: const Icon(
                            Icons.local_fire_department_rounded,
                            color: Color(0xFFff7f3f),
                            size: 38,
                          ),
                          lineWidth: 12,
                          percent: burnGoal == 0
                              ? 0
                              : totalBurntCalories > burnGoal
                                  ? 1
                                  : totalBurntCalories / burnGoal,
                        ),
                      ],
                    ),
                    Text(
                      "Note : To lose healthy weight of 0.5 kg to 1 kg per week you should have a calorie n= burn of 500 to 1000 calories per day",
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Expanded(
                    //           flex: 3,
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Text(
                    //                 'Consumed',
                    //                 style:
                    //                     Theme.of(context).textTheme.labelLarge,
                    //               ),
                    //               Text(
                    //                 '$totalConsumedCalories Cal',
                    //                 style: Theme.of(context)
                    //                     .textTheme
                    //                     .displayLarge,
                    //               ),
                    //               Text(
                    //                 'out of $baseGoal Cal',
                    //                 style:
                    //                     Theme.of(context).textTheme.bodyLarge,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //         CircularPercentIndicator(
                    //           radius: 50,
                    //           animation: true,
                    //           animationDuration: 2000,
                    //           progressColor: const Color(0xFF8E4CED),
                    //           backgroundColor: Colors.white,
                    //           center: const Icon(
                    //             Icons.accessibility_new_rounded,
                    //             color: Color(0xFF8E4CED),
                    //             size: 38,
                    //           ),
                    //           lineWidth: 12,
                    //           percent: baseGoal == 0
                    //               ? 0
                    //               : totalConsumedCalories > baseGoal
                    //                   ? 1
                    //                   : totalConsumedCalories / baseGoal,
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
