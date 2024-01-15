import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/diet_plans/recipies_model.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/recipies/recipe_details_screen.dart';
import 'package:healthonify_mobile/widgets/other/indian_food_mark.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class RecipeCard extends StatefulWidget {
  final RecipiesModel recipiesModel;
  const RecipeCard({Key? key, required this.recipiesModel}) : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: Card(
        child: InkWell(
          onTap: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return RecepieDetailsScreen(recipiesModel: widget.recipiesModel);
          })),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 90),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.recipiesModel.mediaLink!,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Flexible(
                            flex: 1,
                            child: IndianFoodMark(color: Colors.green),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            flex: 5,
                            child: Text(
                              widget.recipiesModel.name!,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.recipiesModel.durationInMinutes != null
                            ? "Preparation time : ${widget.recipiesModel.durationInMinutes} mins"
                            : "Preparation time : 0 mins",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        widget.recipiesModel.calories != null
                            ? "Calories : ${widget.recipiesModel.calories} kcal"
                            : "Calories : 0 kcal",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //   child: PopupMenuButton<Menu>(
                //     padding: EdgeInsets.zero,
                //     constraints: const BoxConstraints(),
                //     splashRadius: 0,
                //     child: const InkWell(
                //       child: Icon(Icons.more_vert),
                //     ),
                //     // Callback that sets the selected popup menu item.
                //     onSelected: (Menu item) {
                //       if (Menu.itemOne == item) {
                //         Navigator.of(context).push(
                //           MaterialPageRoute(
                //             builder: ((context) => const EditRecipe()),
                //           ),
                //         );
                //       }
                //       setState(() {});
                //     },
                //     itemBuilder: (BuildContext context) =>
                //         <PopupMenuEntry<Menu>>[
                //       PopupMenuItem<Menu>(
                //           value: Menu.itemOne,
                //           child: const Text('Edit'),
                //           onTap: () {
                //             log("Hey");
                //           }),
                //       const PopupMenuItem<Menu>(
                //         value: Menu.itemTwo,
                //         child: Text('Delete'),
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
