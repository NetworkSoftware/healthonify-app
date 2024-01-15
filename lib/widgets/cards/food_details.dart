import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FoodDetailsCard extends StatelessWidget {
  const FoodDetailsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          'Consumed',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '1200',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Target',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '2000',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 86,
                          animation: true,
                          animationDuration: 2000,
                          progressColor: const Color(0xFFff7f3f),
                          backgroundColor: Colors.grey[200]!,
                          center: const Icon(
                            Icons.restaurant,
                            color: Color(0xFFff7f3f),
                            size: 36,
                          ),
                          lineWidth: 18,
                          percent: 0.6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        'PROTEIN',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '160 g',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        'CARBS',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '200 g',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        'FAT',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '15 g',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        'FIBRE',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '20 g',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
