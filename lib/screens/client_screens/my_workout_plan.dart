import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/screens/client_screens/exercises_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class MyWorkoutPlanScreen extends StatelessWidget {
  const MyWorkoutPlanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'My Workout Plan',
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                '3 Day workout plan',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: ListTile(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return const CurrentWorkoutPlan();
                  // }));
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ExercisesScreen();
                  }));
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day 1',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Back, Hamstrings, Shoulder',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                  size: 28,
                ),
              ),
            ),
            const Divider(color: grey),
            Padding(
              padding: const EdgeInsets.all(6),
              child: ListTile(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return const CurrentWorkoutPlan();
                  // }));
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ExercisesScreen();
                  }));
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day 2',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Back, Hamstrings, Shoulder',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                  size: 28,
                ),
              ),
            ),
            const Divider(color: grey),
            Padding(
              padding: const EdgeInsets.all(6),
              child: ListTile(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return const CurrentWorkoutPlan();
                  // }));
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ExercisesScreen();
                  }));
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day 3',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Back, Hamstrings, Shoulder',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
