import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/exercise_record.dart';
import 'package:healthonify_mobile/screens/client_screens/workout_completed_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({Key? key}) : super(key: key);

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  bool isStarted = false;
  void startWorkout() {
    setState(() {
      isStarted = !isStarted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Excercises',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: isStarted
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[100],
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.25,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '0 mins',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.black),
                                  ),
                                  Text(
                                    'Workout Time',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.black),
                                  ),
                                ],
                              ),
                              GradientButton(
                                title: 'Save Workout',
                                func: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const WorkoutCompletedScreen();
                                  }));
                                },
                                gradient: orangeGradient,
                              ),
                              // ElevatedButton(
                              //   onPressed: () {
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) {
                              //   return const SaveWorkoutScreen();
                              // }));
                              //   },
                              //   child: const Text('Save Workout'),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return exerciseTile(context);
                      },
                    ),
                  ],
                )
              : Column(
                  children: [
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return exerciseTile(context);
                      },
                    ),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: GradientButton(
          title: 'START WORKOUT',
          func: () {
            startWorkout();
          },
          gradient: orangeGradient,
        ),
      ),
    );
  }

  Widget exerciseTile(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const ExerciseRecordScreen();
        }));
      },
      title: Text(
        'Exercise 1',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey,
        size: 28,
      ),
    );
  }
}
