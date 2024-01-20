// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/create_new_workout.dart';
import 'package:healthonify_mobile/widgets/cards/assign_workout_card.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/client_search.dart';
import 'package:healthonify_mobile/widgets/text%20fields/workout_text_fields.dart';

class AssignWorkoutScreen extends StatefulWidget {
  @override
  State<AssignWorkoutScreen> createState() => _AssignWorkoutScreenState();
}

class _AssignWorkoutScreenState extends State<AssignWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Assign Workout',
         
      ),
      body: SingleChildScrollView(
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
              itemCount: 7,
              itemBuilder: (context, index) {
                return AssignWorkoutCard();
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
}
