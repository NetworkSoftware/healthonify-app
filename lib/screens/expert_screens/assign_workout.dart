// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/workout_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/create_new_workout.dart';
import 'package:healthonify_mobile/widgets/cards/assign_workout_card.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/client_search.dart';
import 'package:healthonify_mobile/widgets/text%20fields/workout_text_fields.dart';
import 'package:provider/provider.dart';

class AssignWorkoutScreen extends StatefulWidget {
  AssignWorkoutScreen({Key? key, this.userId,this.ticketNumber}) : super(key: key);
  final String? userId;
  final String? ticketNumber;

  @override
  State<AssignWorkoutScreen> createState() => _AssignWorkoutScreenState();
}

class _AssignWorkoutScreenState extends State<AssignWorkoutScreen> {
  bool isLoading = false;
  List<WorkoutModel> workoutsList = [];

  Future<void> fetchWorkout() async {
    setState(() {
      isLoading = true;
    });
    var userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      workoutsList = await Provider.of<WorkoutProvider>(context, listen: false)
          .getWorkoutPlan("?expertId=$userId");
      log('fetched workout details');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error getting workout details $e");
      Fluttertoast.showToast(msg: "Unable to fetch workout plans");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWorkout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Assign Workout',
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : workoutsList.isEmpty
              ? const Center(
                  child: Text("No workouts available. Create one now."),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 22),
                        child: ClientSearchBar(),
                      ),
                      ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: workoutsList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: SizedBox(
                                height: 174,
                                width: MediaQuery.of(context).size.width * 0.92,
                                child: Card(
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          workoutsList[index].name!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall,
                                        ),
                                        Text(
                                          'Created on ${StringDateTimeFormat().stringAssignFormat(workoutsList[index].createdAtString!)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        // at ${StringDateTimeFormat().stringAssignTimeFormat(workoutsList[index].createdAtString!)}
                                        const SizedBox(height: 1),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    workoutsList[index]
                                                        .daysInweek!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium,
                                                  ),
                                                  Text(
                                                    'No. of days in a week',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${workoutsList[index].validityInDays!} days',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium,
                                                  ),
                                                  Text(
                                                    'Duration Plan',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () async {
                                              assignWorkoutPlan(workoutsList[index].id!,workoutsList[index].expertId!);
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: orange,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: const Text(
                                                  "Assign To Client",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 34),
                    ],
                  ),
                ),
      bottomSheet: Container(
        height: 64,
        width: MediaQuery.of(context).size.width,
        color: Color(0xFFff7f3f),
        child: TextButton(
          onPressed: () {
            modalSheet();
          },
          child: Text(
            'Create a new workout plan',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: whiteColor),
          ),
        ),
      ),
    );
  }

  final List _workoutDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  bool _check = false;

  void modalSheet() {
    DraggableScrollableSheet(
      initialChildSize: 0.9,
      builder: (context, controller) {
        return ListView(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          children: [
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.88,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Create a workout plan',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: PlanNameTextField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: NoOfDays(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: GoalTextField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: LevelTextField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18),
                        child: DurationTextField(),
                      ),
                      SizedBox(
                        height: 400,
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Card(
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8.0, left: 8),
                                  child: Text(
                                    'Select workout days',
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                ),
                                ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _workoutDays.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _workoutDays[index],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Checkbox(
                                            value: _check,
                                            onChanged: (value) {
                                              setState(
                                                () {
                                                  _check = value!;
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        color: Color(0xFFff7f3f),
                        height: 54,
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CreateNewWorkout();
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Submit',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: whiteColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> assignWorkoutPlan(String workoutPlanId, String expertId) async {
    try {
      await Provider.of<WorkoutProvider>(context, listen: false)
          .assignWorkoutPlan({
        "workoutPlanId": workoutPlanId,
        "userId": widget.userId,
        "expertId": expertId,
        "ticketNumber": widget.ticketNumber,
      });
      //popScreen();
    } on HttpException catch (e) {
      log("error assigning user ${e.toString}");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error assigning user ${e.toString}");
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }
}
