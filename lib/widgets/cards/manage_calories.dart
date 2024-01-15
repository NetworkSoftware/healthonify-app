import 'package:flutter/material.dart';
import 'package:healthonify_mobile/providers/trackers/calorie_tracker_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/calories_details.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class CaloriesCard extends StatelessWidget {
  const CaloriesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalConsumedCalories = 0;
    int totalBurntCalories = 0;
    int baseGoal = 0;
    int burnGoal = 0;

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
        burnGoal =
            double.parse(value.calorieData.caloriesBurntGoal ?? "0").round();
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
                  return const CalorieDetailScreen();
                }));
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       flex: 3,
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text(
                    //             'Burnt',
                    //             style: Theme.of(context).textTheme.labelLarge,
                    //           ),
                    //           Text(
                    //             '$totalBurntCalories Cal',
                    //             style: Theme.of(context).textTheme.displayLarge,
                    //           ),
                    //           Text(
                    //             'out of $burnGoal Cal',
                    //             style: Theme.of(context).textTheme.bodyLarge,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     CircularPercentIndicator(
                    //       radius: 50,
                    //       animation: true,
                    //       animationDuration: 2000,
                    //       progressColor: const Color(0xFFff7f3f),
                    //       backgroundColor: Colors.white,
                    //       center: const Icon(
                    //         Icons.local_fire_department_rounded,
                    //         color: Color(0xFFff7f3f),
                    //         size: 38,
                    //       ),
                    //       lineWidth: 12,
                    //       percent: burnGoal == 0
                    //           ? 0
                    //           : totalBurntCalories > burnGoal
                    //               ? 1
                    //               : totalBurntCalories / burnGoal,
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Column(
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
                                    'Consumed',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  Text(
                                    '$totalConsumedCalories Cal',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                  ),
                                  Text(
                                    'out of $baseGoal Cal',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                            CircularPercentIndicator(
                              radius: 50,
                              animation: true,
                              animationDuration: 2000,
                              progressColor: const Color(0xFF8E4CED),
                              backgroundColor: Colors.white,
                              center: const Icon(
                                Icons.accessibility_new_rounded,
                                color: Color(0xFF8E4CED),
                                size: 38,
                              ),
                              lineWidth: 12,
                              percent: baseGoal == 0
                                  ? 0
                                  : totalConsumedCalories > baseGoal
                                      ? 1
                                      : totalConsumedCalories / baseGoal,
                            ),
                          ],
                        ),
                      ],
                    ),
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
