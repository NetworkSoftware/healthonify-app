import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/cards/new_workout_card.dart';

class CreateNewWorkout extends StatelessWidget {
  const CreateNewWorkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: '',
         
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Beginner',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NewWorkoutCard1(workoutDay: 'Day 1'),
                ],
              ),
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, index) {
                return const NewWorkoutCard2(workoutDay: 'Day 1');
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
