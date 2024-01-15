import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/workout_data.dart';
import 'package:healthonify_mobile/screens/client_screens/fitness_tools/browse_fitness_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/my_workout/expert_assigned_workout_plans.dart';
import 'package:healthonify_mobile/screens/client_screens/my_workout/my_workoutplans.dart';
import 'package:healthonify_mobile/screens/client_screens/standard_plans.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class CurrentWorkoutPlan extends StatelessWidget {
  CurrentWorkoutPlan({Key? key}) : super(key: key);
  List<WorkoutModel> workoutsList = [];

  List<WorkoutModel> currentWorkoutsList = [];

  Future<void> fetchAssignedWorkout(BuildContext context) async {
    var userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      currentWorkoutsList =
          await Provider.of<WorkoutProvider>(context, listen: false)
              .getUserWorkoutPlan("$userId");
      log('fetched workout details');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error getting workout details $e");
      Fluttertoast.showToast(msg: "Unable to fetch workout plans");
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'My Workout Plan',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GradientButton(
                        title: 'My Workout Plans',
                        func: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return const MyWorkouts();
                              }));
                        },
                        gradient: orangeGradient,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: GradientButton(
                        title: 'Expert assigned Plans',
                        func: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return const ExpertAssignedWorkoutPlans();
                              }));
                        },
                        gradient: orangeGradient,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Current Workout Plan',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              FutureBuilder(
                future: fetchAssignedWorkout(context),
                builder: (context, snapshot) => snapshot.connectionState ==
                        ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : currentWorkoutsList.isEmpty
                        ? const Center(
                            child: Text("No plans assigned"),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: currentWorkoutsList.length > 1 ? 1 : 0,
                            itemBuilder: (context, index) => workoutPlanCards(
                              context,
                              '${currentWorkoutsList[index].name}',
                              () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return StandardPlans(
                                    workoutModel: currentWorkoutsList[index],
                                  );
                                }));
                              },
                            ),
                          ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Available Free Workout Plans',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              FutureBuilder(
                future: fetchWorkout(context),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: workoutsList.length,
                            itemBuilder: (context, index) {
                              return workoutPlanCards(
                                context,
                                workoutsList[index].name!,
                                () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return StandardPlans(
                                      workoutModel: workoutsList[index],
                                    );
                                  }));
                                },
                              );
                            },
                          ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BrowseFitnessPlans(isExpertCurated: true),
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 70, minHeight: 40),
                      decoration: BoxDecoration(
                          gradient: orangeGradient,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Try our Expert Plans',
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: whiteColor),
                          ),
                          const SizedBox(width: 10),
                          Image.asset("assets/images/expert_plans.png",color: whiteColor,height: 20,width:20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                'Extremely customised workout plans designed to get results specifically for you',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       GradientButton(
              //         title: 'Expert Curated Plans',
              //         func: () {
              //           Navigator.of(context).push(
              //             MaterialPageRoute(
              //               builder: (context) => const BrowseFitnessPlans(isExpertCurated: true),
              //             ),
              //           );
              //           // Navigator.push(context,
              //           //     MaterialPageRoute(builder: (context) {
              //           //   return const PlanDetailsScreen();
              //           // }));
              //         },
              //         gradient: orangeGradient,
              //       ),
              //     ],
              //   ),
              // ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(color: Colors.grey,),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                child: GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const BrowseFitnessPlans(isPersonalTrainer: true),
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 70, minHeight: 40),
                      decoration: BoxDecoration(
                          gradient: orangeGradient,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Trainer Plans',
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: whiteColor),
                          ),
                          const SizedBox(width: 10),
                          Image.asset("assets/images/expert_plans.png",color: whiteColor,height: 20,width:20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'For great results try our Personal Trainers',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<WorkoutModel>> fetchWorkout(BuildContext context) async {
    try {
      workoutsList = await Provider.of<WorkoutProvider>(context, listen: false)
          .getWorkoutPlan("?type=free");
      log('fetched workout details');
      return workoutsList;
    } on HttpException catch (e) {
      log("Error getting workout details current workout plan http.. $e");
      // Fluttertoast.showToast(msg: "Something went wrong");
      return workoutsList;
    } catch (e) {
      log("Error getting workout details current workout plan $e");
      // Fluttertoast.showToast(msg: "Unable to fetch workout plans");
      return workoutsList;
    } finally {}
  }

  Widget workoutPlanCards(
      BuildContext context, String title, Function onTouch) {
    return Card(
      child: ListTile(
        onTap: () {
          onTouch();
        },
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey,
          size: 28,
        ),
      ),
    );
  }
}
