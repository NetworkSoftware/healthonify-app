import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/screens/client_screens/standard_plans.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class MyCareplanWorkout extends StatelessWidget {
  const MyCareplanWorkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'My Workout Plans',
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No workout plans available. Click on the button below to start tracking your routines',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return StandardPlans(
                        workoutModel: WorkoutModel(),
                      );
                    }));
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      'Try our standard plans',
                    ),
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
