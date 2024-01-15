import 'package:flutter/material.dart';
import 'package:healthonify_mobile/func/diet/meals_switch_case.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/meal_plans_screen.dart';
import 'package:provider/provider.dart';

class ManageCaloriesTracker extends StatefulWidget {
  const ManageCaloriesTracker({Key? key}) : super(key: key);

  @override
  State<ManageCaloriesTracker> createState() => _ManageCaloriesTrackerState();
}

class _ManageCaloriesTrackerState extends State<ManageCaloriesTracker> {
  User userData = User();
  @override
  void initState() {
    super.initState();

    userData = Provider.of<UserData>(context, listen: false).userData;
    var dietData = Provider.of<AllTrackersData>(context, listen: false)
            .allTrackersData
            .calorieProgress!["totalDietAnalysisData"]["dietPercentagesData"]
        as List<dynamic>;

    meals = [
      {
        'meal': 'Breakfast',
        'mealGoal': userData.breakfastGoal,
      },
      {
        'meal': 'Morning Snack',
        'mealGoal': userData.morningSnacksGoal,
      },
      {
        'meal': 'Lunch',
        'mealGoal': userData.lunchGoal,
      },
      {
        'meal': 'Afternoon Snack',
        'mealGoal': userData.afternoonSnacksGoal,
      },
      {
        'meal': 'Dinner',
        'mealGoal': userData.dinnerGoal,
      },
    ];
  }

  List meals = [];

  @override
  Widget build(BuildContext context) {
    var dietData = Provider.of<AllTrackersData>(context)
            .allTrackersData
            .calorieProgress!["totalDietAnalysisData"]["dietPercentagesData"]
        as List<dynamic>;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 4),
          child: Text(
            'Diet Log',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        SizedBox(
          // color: Colors.white,
          height: 106,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: meals.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SizedBox(
                  width: 140,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(
                          context, /*rootnavigator: true*/
                        ).push(MaterialPageRoute(builder: (context) {
                          return MealPlansScreen(
                            isWm: true,
                            mealName: MealSwitchCase()
                                .upperToLower(meals[index]["meal"]),
                          );
                        }));
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            meals[index]['meal'],
                            style: Theme.of(context).textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${dietData[index]["caloriesCount"]}/${meals[index]['mealGoal']}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const Icon(
                            Icons.add_rounded,
                            color: Color(0xFFff7f3f),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String getCalorieCount(List data, String mealName) {
    for (var ele in data) {
      if (identical(ele["name"], mealName)) {
        return ele["caloriesCount"];
      }
    }
    return "0";
  }
}
