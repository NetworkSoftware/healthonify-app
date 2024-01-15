import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar_w_dropdown.dart';
import 'package:healthonify_mobile/widgets/cards/food_card.dart';
import 'package:healthonify_mobile/widgets/cards/nutrition_card.dart';
import 'package:healthonify_mobile/widgets/cards/sleep_card.dart';
import 'package:healthonify_mobile/widgets/cards/steps_card.dart';
import 'package:healthonify_mobile/widgets/cards/track_calories.dart';
import 'package:healthonify_mobile/widgets/cards/water_card.dart';
import 'package:healthonify_mobile/widgets/cards/weight_card.dart';
import 'package:healthonify_mobile/widgets/cards/workout_card.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarwDropDown(
        appBarTitle: 'Hi! Sarah.',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FoodCard(),
                  WorkoutCard(),
                ],
              ),
            ),
            const StepsCard(),
            const SizedBox(height: 22),
            const SleepCard(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Text(
                    'Nutrition',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            const NutritionCard(),
            const SizedBox(height: 22),
            const TrackCalories(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  WeightCard(),
                  WaterCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
