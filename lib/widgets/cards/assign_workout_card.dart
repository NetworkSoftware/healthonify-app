import 'package:flutter/material.dart';

class AssignWorkoutCard extends StatelessWidget {
  const AssignWorkoutCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: SizedBox(
          height: 174,
          width: MediaQuery.of(context).size.width * 0.92,
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Beginner',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12),
                        child: const Icon(
                          Icons.more_vert,
                          color: Color(0xFF717579),
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Created on 29/03/2022 at 4:57 pm',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 1),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '5',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              'No. of days in a week',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '45 days',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Text(
                              'Duration Plan',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
