import "package:flutter/material.dart";

class CaloriesMealCard extends StatelessWidget {
  final bool? showGoal;
  final double proteins, carbs, fats, fiber, totalCalories;
  const CaloriesMealCard(
      {Key? key,
      this.showGoal = false,
      this.proteins = 0.0,
      this.carbs = 0.0,
      this.fats = 0.0,
      this.fiber = 0.0,
      this.totalCalories = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showGoal!)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Calorie Goal',
                          style: Theme.of(context).textTheme.labelMedium),
                      Text('2000 kCal',
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Calories',
                        style: Theme.of(context).textTheme.labelMedium),
                    Text('${totalCalories.toStringAsFixed(2)} kCal',
                        style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          'assets/icons/protiens.png',
                          height: 34,
                          width: 34,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text('Protiens',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            '$proteins gms',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          'assets/icons/carbs.png',
                          height: 34,
                          width: 34,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text('Carbs',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            '$carbs gms',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          'assets/icons/fats.png',
                          height: 34,
                          width: 34,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text('Fats',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            '$fats gms',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          'assets/icons/fiber.png',
                          height: 34,
                          width: 34,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text('Fibers',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            '$fiber gms',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
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
    );
  }
}
