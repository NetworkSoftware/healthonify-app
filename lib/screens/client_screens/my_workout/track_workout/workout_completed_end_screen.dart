import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/func/workout/workout_func.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/providers/trackers/calorie_tracker_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkoutCompletedEndScreen extends StatelessWidget {
  final String workoutId;
  final Schedule schedule;
  final String time;
  List<ExerciseWorkoutModel> selectedExs;

  WorkoutCompletedEndScreen(
      {Key? key,
      required this.workoutId,
      required this.schedule,
      required this.selectedExs,
      required this.time})
      : super(key: key);

  Map<String, dynamic> data = {};

  Future<void> getResults(BuildContext context) async {
    data = await WorkoutFunc().postWorkoutLog(context,
        schedule: schedule, workoutId: workoutId, selectedExs: selectedExs);
    log("log workout data ${json.encode(data)}");
    String userId =
    Provider.of<UserData>(context, listen: false).userData.id!;

    await Provider.of<CalorieTrackerProvider>(context, listen: false).getCalories(
        "?userId=$userId&date=${DateFormat("yyyy-MM-dd").format(DateTime.now())}");
  }

  int totalReps() {
    int reps = 0;
    for (var ele in selectedExs) {
      for (var sets in ele.sets!) {
        int temp = 0;
        if (sets.reps != null || sets.reps!.isNotEmpty) {
          temp = int.parse(sets.reps!);
        }
        reps = reps + temp;
      }
    }
    log("reps calculated $reps");
    return reps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: '',
      ),
      body: FutureBuilder(
        future: getResults(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : data.isEmpty
                ? const Center(
                    child: Text("Something went wrong"),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Text(
                          'Hope you had an amazing workout!',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 10),
                                child: Text(
                                  'Workout Recorded',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ),
                              Center(
                                child: Text(
                                  schedule.note ?? "",
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 12,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.schedule_outlined,
                                          size: 22,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${int.parse(time) <= 1 ? "$time min" : "$time mins"} ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),

                                    // const Icon(
                                    //   Icons.fitness_center_rounded,
                                    //   size: 22,
                                    // ),
                                    // Text(
                                    //   '60 kgs',
                                    //   style: Theme.of(context)
                                    //       .textTheme
                                    //       .bodyMedium,
                                    // ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.replay_10_rounded,
                                          size: 22,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${totalReps.call()} reps',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${selectedExs.length} x Exercise',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                    // Text(
                                    //   '${totalReps.call()} reps  60 kgs',
                                    //   style: Theme.of(context)
                                    //       .textTheme
                                    //       .labelMedium,
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 10),
                      //   child: ListTile(
                      //     onTap: () {},
                      //     title: Text(
                      //       'Edit Workout',
                      //       style: Theme.of(context).textTheme.bodyMedium,
                      //     ),
                      //     trailing: const Icon(
                      //       Icons.chevron_right_rounded,
                      //       color: Colors.grey,
                      //       size: 28,
                      //     ),
                      //   ),
                      // ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.tips_and_updates_outlined,
                                    color: Colors.yellow,
                                    size: 26,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Tips',
                                    style:
                                        Theme.of(context).textTheme.labelMedium,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'Had a great workout session.Its important to cool down properly.use right stretches to cool down the exercised muscles.Keep working hard.Health is wealth.',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
