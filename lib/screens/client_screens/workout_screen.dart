import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/add_workout.dart';
import 'package:healthonify_mobile/widgets/cards/average_calories_burnt.dart';
import 'package:healthonify_mobile/widgets/cards/steps_card.dart';
import 'package:healthonify_mobile/widgets/cards/track_workout.dart';
import 'package:healthonify_mobile/widgets/cards/workout_details.dart';
import 'package:healthonify_mobile/widgets/other/calendar_appbar.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CalendarAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WorkoutDetailsCard(),
              ],
            ),
            const SizedBox(height: 22),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StepsCard(),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Track your workout',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TrackWorkoutCard(),
              ],
            ),
            const SizedBox(height: 22),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AddWorkoutCard(),
              ],
            ),
            const SizedBox(height: 22),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AverageCalBurntCard(),
              ],
            ),
            const SizedBox(height: 22),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ReminderCard(),
              ],
            ),
            const SizedBox(height: 34),
          ],
        ),
      ),
    );
  }
}
