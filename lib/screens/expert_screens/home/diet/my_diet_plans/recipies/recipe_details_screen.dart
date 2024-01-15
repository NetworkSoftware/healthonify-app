import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/diet_plans/recipies_model.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/indian_food_mark.dart';
import 'package:healthonify_mobile/widgets/wm/dietplan/recipe_calorie_meal_goal_card.dart';

class RecepieDetailsScreen extends StatelessWidget {
  final RecipiesModel recipiesModel;
  const RecepieDetailsScreen({Key? key, required this.recipiesModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: recipiesModel.name!,
        // widgetRight: CustomAppBarTextBtn(
        //   title: "Edit",
        //   onClick: () {
        //     Navigator.of(context)
        //         .push(MaterialPageRoute(builder: (_) => const EditRecipe()));
        //   },
        // )
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  recipiesModel.mediaLink!,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Flexible(
                      child: IndianFoodMark(color: Colors.green),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        recipiesModel.name!,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        recipiesModel.durationInMinutes != null
                            ? "${recipiesModel.durationInMinutes} Mins"
                            : "0 Mins",
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                RecipeCaloriesMealCard(
                  showGoal: false,
                  recipiesModel: recipiesModel,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Description",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("Ingredients:"),
                Text(recipiesModel.ingredients!),
                const SizedBox(
                  height: 10,
                ),
                const Text("Method:"),
                Text(recipiesModel.method!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
