// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar_w_dropdown.dart';
import 'package:healthonify_mobile/widgets/cards/food_details.dart';
import 'package:healthonify_mobile/widgets/cards/meal_details.dart';

class FoodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarwDropDown(
        appBarTitle: 'Food',
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FoodDetailsCard(),
              ],
            ),
            MealDetailsCard(
              meal: 'Breakfast',
              calories: 417,
              mealName: 'Chicken Biryani',
            ),
            MealDetailsCard(
              meal: 'Morning Snack',
              calories: 0,
              mealName: '',
            ),
            MealDetailsCard(
              meal: 'Lunch',
              calories: 0,
              mealName: '',
            ),
            MealDetailsCard(
              meal: 'Evening Snack',
              calories: 0,
              mealName: '',
            ),
            MealDetailsCard(
              meal: 'Dinner',
              calories: 0,
              mealName: '',
            ),
          ],
        ),
      ),
    );
  }
}
