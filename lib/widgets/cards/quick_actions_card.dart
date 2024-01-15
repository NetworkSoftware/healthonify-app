import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/client/home_client/home_quick_actions.dart';
import 'package:healthonify_mobile/constants/client/physio/quick_actions_list.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/body_measurements/body_measurements.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_form/my_subscription.dart';
import 'package:healthonify_mobile/screens/client_screens/my_workout/current_workout_plan.dart';
import 'package:healthonify_mobile/screens/client_screens/health_locker/health_locker.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/meal_plans_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/quick_actions/browse_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/weekly_diet_details.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/wm_subscriptions.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/workout_analysis/workout_analysis.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/my_diet_plans_screen.dart';
import 'package:healthonify_mobile/screens/my_diary/my_diary.dart';

class HomeQuickActionsCard extends StatelessWidget {
  const HomeQuickActionsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Card(
              elevation: 0,
              color: orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 120,
                  childAspectRatio: 10.0,
                  crossAxisSpacing: 0.1,
                ),
                itemCount: homeQuickActionsList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () =>
                        homeQuickActionsList[index]['onClick'](context),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black,width: 0.3),
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).drawerTheme.backgroundColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            homeQuickActionsList[index]["icon"],
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            homeQuickActionsList[index]["title"],
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          //const Divider(thickness: 2),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class QuickActionCard2 extends StatelessWidget {
  const QuickActionCard2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {
        "title": 'Workout Plan',
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CurrentWorkoutPlan();
          }));
        },
        "icon": 'assets/icons/workout.png',
      },
      {
        "title": 'Workout Analysis',
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const WorkoutAnalysisScreen();
          }));
        },
        "icon": 'assets/icons/workout_analysis.png',
      },
      {
        "title": 'Weekly Diet Analysis',
        "onClick": () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const WeeklyDietAnalysis();
          }));
        },
        "icon": 'assets/icons/weekly_analysis.png',
      },
      {
        "title": 'Log Weight',
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const WeightScreen();
          }));
        },
        "icon": 'assets/icons/log_weight.png',
      },
      {
        "title": 'Measurement',
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const BodyMeasurementsScreen();
          }));
        },
        "icon": 'assets/icons/measure.png',
      },
      // {
      //   "title": 'My Subscription',
      //   "onClick": () {
      //     // Navigator.of(context, /*rootnavigator: true*/)
      //     //     .push(MaterialPageRoute(builder: (context) {
      //     //   return const AllSubscriptions();
      //     // }));
      //     Navigator.of(context).push(MaterialPageRoute(
      //       builder: (context) => MySubscriptions(),
      //     ));
      //   },
      //   "icon": 'assets/icons/subscription.png',
      // },
      {
        "title": 'My Diary',
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MyDiary();
          }));
        },
        "icon": 'assets/icons/diary.png',
      },
    ];
    return  Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          elevation: 0,
          color: orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: GridView.builder(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 120,
              childAspectRatio: 10.0,
              crossAxisSpacing: 0.1,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () =>
                    data[index]['onClick'](context),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black,width: 0.3),
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).drawerTheme.backgroundColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        data[index]["icon"],
                        height: 40,
                        width: 40,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data[index]["title"],
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      //const Divider(thickness: 2),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class QuickActionCard3 extends StatelessWidget {
  const QuickActionCard3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8),
              child: Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.98,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      // childAspectRatio: 2 / 1.8,
                      mainAxisExtent: 122,
                    ),
                    itemCount: physioQuickActions.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () =>
                            physioQuickActions[index]["onClick"](context),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Image.asset(
                                physioQuickActions[index]['icon'],
                                height: 40,
                                width: 40,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                physioQuickActions[index]['title'],
                                style: Theme.of(context).textTheme.labelSmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickActionCardWM extends StatelessWidget {
  const QuickActionCardWM({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data = [
      {
        "title": "Diet Plans",
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MyDietPlans();
          }));
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => const TrackNutritionScreen(),
          //   ),
          // );
        },
        "icon": 'assets/icons/diet.png',
      },
      {
        "title": 'Diet Tracker',
        "onClick": () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MealPlansScreen(),
            ),
          );
        },
        "icon": 'assets/icons/track_diet.png',
      },
      {
        "title": 'Workout Plan',
        "onClick": () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return CurrentWorkoutPlan();
              },
            ),
          );
        },
        "icon": 'assets/icons/workout.png',
      },
      {
        "title": 'Workout Analysis',
        "onClick": () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const WorkoutAnalysisScreen();
              },
            ),
          );
        },
        "icon": 'assets/icons/workout_analysis.png',
      },
      {
        "title": 'My Subscriptions',
        "onClick": () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WmAllSubscriptions(),
          ));
          // Navigator.of(context, /*rootnavigator: true*/)
          //     .push(MaterialPageRoute(builder: (context) {
          //   return const AllSubscriptions();
          // }));
        },
        "icon": 'assets/icons/therapy.png',
      },
      {
        "title": 'View Plans',
        "onClick": () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const WmPackagesQuickActionsScreen(),
            ),
          );
        },
        "icon": 'assets/icons/track_diet.png',
      },
      {
        "title": 'Health Locker',
        "onClick": () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const HealthLockerScreen();
              },
            ),
          );
        },
        "icon": 'assets/icons/digi_locker.png',
      },
      {
        "title": 'Measurements',
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const BodyMeasurementsScreen();
          }));
        },
        "icon": 'assets/icons/measure.png',
      },
      {
        "title": 'My Diary',
        "onClick": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MyDiary();
          }));
        },
        "icon": 'assets/icons/diary.png',
      },
    ];

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.98,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  // childAspectRatio: 2 / 1.8,
                  mainAxisExtent: 122,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: data[index]["onClick"],
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Image.asset(
                            data[index]["icon"],
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            data[index]["title"],
                            style: Theme.of(context).textTheme.labelSmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
