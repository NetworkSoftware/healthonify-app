import "package:flutter/material.dart";
import 'package:healthonify_mobile/models/diet_plans/recipies_model.dart';

class RecipeCaloriesMealCard extends StatelessWidget {
  final bool? showGoal;
  final RecipiesModel recipiesModel;
  const RecipeCaloriesMealCard({
    Key? key,
    this.showGoal = false,
    required this.recipiesModel,
  }) : super(key: key);

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
                    Text('${recipiesModel.calories ?? "0"} kCal',
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
                            '${recipiesModel.protiens ?? "0"} gms',
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
                            '${recipiesModel.carbs ?? "0"} gms',
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
                            '${recipiesModel.fats ?? "0"} gms',
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
                            '${recipiesModel.fiber ?? "0"} gms',
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
