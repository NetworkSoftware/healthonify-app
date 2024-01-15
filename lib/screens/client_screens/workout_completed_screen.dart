import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class WorkoutCompletedScreen extends StatelessWidget {
  const WorkoutCompletedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: '',
      ),
      body: SafeArea(
        child: Column(
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
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    Center(
                      child: Text(
                        'Back, Hamstrings, Shoulder',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
                            Icons.schedule_outlined,
                            size: 22,
                          ),
                          Text(
                            '20 mins',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Icon(
                            Icons.fitness_center_rounded,
                            size: 22,
                          ),
                          Text(
                            '60 kgs',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Icon(
                            Icons.replay_10_rounded,
                            size: 22,
                          ),
                          Text(
                            '80 reps',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '3 x Exercise',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            '80 reps  60 kgs',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                onTap: () {},
                title: Text(
                  'Edit Workout',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                  size: 28,
                ),
              ),
            ),
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
                          style: Theme.of(context).textTheme.labelMedium,
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
