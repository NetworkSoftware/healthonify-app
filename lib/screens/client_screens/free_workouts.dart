import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class FreeWorkoutScreen extends StatelessWidget {
  const FreeWorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List freePlans = [
      {
        'title': 'Beginner',
        'plans': [
          'Plan 1',
          'Plan 2',
        ],
      },
      {
        'title': 'Intermediate',
        'plans': [
          'Plan 1',
          'Plan 2',
        ],
      },
      {
        'title': 'Superior',
        'plans': [
          'Superior Plan 1',
          'Superior Plan 2',
        ],
      },
      {
        'title': 'Celebrity Expert Plans',
        'plans': [
          'Celebrity Expert Plan 1',
          'Celebrity Expert Plan 2',
        ],
      },
      {
        'title': 'Free Body Weight Plans',
        'plans': [
          'Free Body Weight Plan 1',
          'Free Body Weight Plan 2',
        ],
      },
      {
        'title': 'Zumba Workouts',
        'plans': [
          'Zumba Workout 1',
          'Zumba Workout 2',
        ],
      },
      {
        'title': 'Cardiovascular Exercises',
        'plans': [
          'Cardiovascular Exercise 1',
          'Cardiovascular Exercise 2',
        ],
      },
      {
        'title': 'Fat Loss Exercises',
        'plans': [
          'Fat Loss Exercise 1',
          'Fat Loss Exercise 2',
        ],
      },
      {
        'title': 'Mobility Exercises',
        'plans': [
          'Mobility Exercise 1',
          'Mobility Exercise 2',
        ],
      },
    ];
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: ''),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  'Experience Free Workout Plans',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: freePlans.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          freePlans[index]['title'],
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: freePlans[index]['plans'].length,
                        itemBuilder: (context, index) {
                          return workoutPlanCards(
                            context,
                            freePlans[index]['plans'][index],
                            () {},
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Try our Expert Plans',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Text(
              'Extremely customised workout plans designed to get results specifically for you',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientButton(
                    title: 'Expert Curated Plans',
                    func: () {},
                    gradient: orangeGradient,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'For great results try our Personal Trainers',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientButton(
                    title: 'Personal Trainer Plans',
                    func: () {},
                    gradient: orangeGradient,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
