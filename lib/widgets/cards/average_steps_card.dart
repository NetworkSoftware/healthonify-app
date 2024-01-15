import 'package:flutter/material.dart';

class AverageStepsCard extends StatelessWidget {
  const AverageStepsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 2,
              ),
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'Average',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 2,
              ),
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    '7000 ',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'steps',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 2,
              ),
              child: Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'This week',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Image.asset('assets/icons/graph.png'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
