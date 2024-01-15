import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class TrackNutritionScreen extends StatelessWidget {
  const TrackNutritionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: '',
         
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/fruits.png',
            height: 100,
            width: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Lets track your nutrition',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'In order to start nutrition tracking, calculate how much calories you need to eat.',
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 28),
            child: CalcCalorieIntakeButton(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Text(
              'OR',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const ManualEntryCalorieButton(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Text(
              'OR',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const StartTrackingButton(),
        ],
      ),
    );
  }
}
