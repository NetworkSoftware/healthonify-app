import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/screens/client_screens/my_workout/track_workout/timer_card.dart';
import 'package:healthonify_mobile/screens/client_screens/my_workout/track_workout/workout_completed_end_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/edit_hep_plan.dart';

class TrackWorkout extends StatefulWidget {
  final Schedule schedule;
  final String workoutPlanId;
  final String title;

  const TrackWorkout({
    Key? key,
    required this.title,
    required this.workoutPlanId,
    required this.schedule,
  }) : super(key: key);

  @override
  State<TrackWorkout> createState() => _TrackWorkoutState();
}

class _TrackWorkoutState extends State<TrackWorkout> {
  List<ExerciseWorkoutModel> exmodel = [];
  bool isWorkoutStarted = false;
  final Stopwatch stopwatch = Stopwatch();
  List<ExerciseWorkoutModel> selectedExs = [];

  void saveTime(String timeInMinutes) {
    log("Time in minutes $timeInMinutes");
    if (selectedExs.isEmpty) {
      Fluttertoast.showToast(msg: "Please select atleast one exercise");
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => WorkoutCompletedEndScreen(
                  schedule: widget.schedule,
                  workoutId: widget.workoutPlanId,
                  selectedExs: selectedExs,
                  time: timeInMinutes,
                )),
        (route) => route.isFirst);
  }

  @override
  void initState() {
    super.initState();
    if (widget.schedule.exercises != null) {
      exmodel.addAll(widget.schedule.exercises!);
    }
  }

  void updatePlan(ExerciseWorkoutModel ex, int index) {
    log(" index $index");
    setState(() {
      exmodel[index] = ex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: widget.title,
      ),
      body: exmodel.isEmpty
          ? const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Center(child: Text("No exercises added")),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 15.0, vertical: 5),
                  //   child: TimerCard(saveTime: saveTime),
                  // ),
                  // if (isWorkoutStarted)
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 15.0, vertical: 5),
                  //     child: TimerCard(saveTime: saveTime),
                  //   ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: exmodel.length,
                    itemBuilder: (_, index) => EditHepPlan(
                      exData: exmodel[index],
                      isEdit: false,
                      updateEditedPlan: updatePlan,
                      index: index,
                      hasWorkoutStarted: isWorkoutStarted,
                      addEx: ({required ExerciseWorkoutModel data}) {
                        selectedExs.add(data);
                        // log("length ${selectedExs.length}");
                      },
                      removeEx: ({required ExerciseWorkoutModel data}) {
                        selectedExs.remove(data);
                        // log("length ${selectedExs.length}");
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: isWorkoutStarted
          ? const SizedBox()
          : Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: orangeGradient,
              ),
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text('Do you wish to end this workout?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            int time = 0;
                            for (int i = 0; i < selectedExs.length; i++) {
                              for (int j = 0;
                                  j < selectedExs[i].sets!.length;
                                  j++) {
                                time +=
                                    int.parse(selectedExs[i].sets![j].time!) ??
                                        0;
                              }
                            }

                            print("Time Spend : $time");
                            saveTime(time.toString());
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Finish Workout',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: whiteColor),
                ),
              ),
            ),
    );
  }
}
