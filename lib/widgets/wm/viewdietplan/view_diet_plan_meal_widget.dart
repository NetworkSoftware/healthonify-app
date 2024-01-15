import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/wm/create_diet_plan_models.dart';
import 'package:healthonify_mobile/models/wm/diet_plan_model.dart';
import 'package:healthonify_mobile/models/wm/dish_model.dart';
import 'package:healthonify_mobile/screens/client_screens/add_food_screen.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class ViewDietPlanMealWidget extends StatefulWidget {
  final List<GetDish> dishes;
  final double? proteins, carbs, fats, fiber;
  final bool isEdit;
  final bool isLog;
  final Function calculateCalories;
  const ViewDietPlanMealWidget({
    Key? key,
    required this.dishes,
    required this.proteins,
    required this.isEdit,
    required this.carbs,
    required this.fats,
    this.isLog = false,
    required this.fiber,
    required this.calculateCalories,
  }) : super(key: key);

  @override
  State<ViewDietPlanMealWidget> createState() => _ViewDietPlanMealWidgetState();
}

class _ViewDietPlanMealWidgetState extends State<ViewDietPlanMealWidget> {
  void pushAddAlternateDish(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const AddFoodScreen();
        },
      ),
    ).then((dish) {
      if (dish == null) {
        return;
      }
      CreateDietDish tempDish = dish;

      GetDish tempAltDish = GetDish(
        dishId: DishId(
          id: tempDish.dishId,
          unit: 0,
          name: tempDish.name,
          nutrition: List.generate(
            tempDish.nutrition == null ? 0 : tempDish.nutrition!.length,
            (index) {
              Nutrition nutr = tempDish.nutrition![index];
              return GetNutrition(
                  carbs: NutritionDetails(quantity: nutr.carbs!.quantity),
                  fats: NutritionDetails(quantity: nutr.fats!.quantity),
                  fiber: NutritionDetails(quantity: nutr.fiber!.quantity),
                  proteins: NutritionDetails(quantity: nutr.proteins!.quantity),
                  id: nutr.id);
            },
          ),
          perUnit: GetPerUnit(
            calories: tempDish.perUnit!.calories,
            quantity: tempDish.perUnit!.quantity,
            weight: tempDish.perUnit!.weight.toString(),
          ),
        ),
        quantity: tempDish.quantity,
        unit: tempDish.unit,
      );

      if (widget.dishes[index].alternateFood != null) {
        widget.dishes[index].alternateFood!.add(tempAltDish);
      } else {
        widget.dishes[index].alternateFood ??= [tempAltDish];
      }
      setState(() {});
      // log("alt dish ${tempDish.quantity!}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${widget.proteins} gms',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${widget.carbs} gms',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${widget.fats} gms',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${widget.fiber} gms',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Protiens',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Carbs',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Fats',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Fibers',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.dishes.length,
            itemBuilder: (context, index) => foodLayout(
              widget.dishes[index],
              index,
            ),
          )
        ],
      ),
    );
  }

  Widget foodLayout(GetDish dish, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                  '${dish.dishId!.name}',
                  style: Theme.of(context).textTheme.labelLarge,
                )),
                if (widget.isEdit)
                  PopupMenuButton<Menu>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (Menu item) {
                      log("hey");
                      if (item == Menu.itemTwo) {
                        widget.dishes.removeAt(index);
                        widget.calculateCalories();
                        setState(() {});
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<Menu>>[
                      // const PopupMenuItem<Menu>(
                      //   value: Menu.itemOne,
                      //   child: Text('Edit'),
                      // ),
                      const PopupMenuItem<Menu>(
                        value: Menu.itemTwo,
                        child: Text('Delete'),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Calories : ${(dish.quantity! * dish.dishId!.perUnit!.calories!).toStringAsFixed(2)} kcal  Quantity : ${dish.quantity} ${dish.dishId!.perUnit!.quantity}',
            ),
          ],
        ),
        dish.alternateFood != null && dish.alternateFood!.isNotEmpty
            ? TextButton(
                onPressed: () {
                  showAlternateFoodDialog(dish.alternateFood!, index);
                },
                child: const Text("View  Alternate Food"),
              )
            : widget.isEdit && !widget.isLog
                ? TextButton(
                    onPressed: () {
                      pushAddAlternateDish(index);
                    },
                    child: const Text("Add Alternate Food"),
                  )
                : const SizedBox(
                    height: 15,
                  ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Divider(
            color: Theme.of(context).colorScheme.secondary,
          ),
        )
      ],
    );
  }

  Widget popupMenu(int dishIndex, int alternateFoodIndex) {
    return PopupMenuButton<Menu>(
      icon: const Icon(Icons.more_vert),
      onSelected: (Menu item) {
        if (item == Menu.itemTwo) {
          widget.dishes[dishIndex].alternateFood!.removeAt(alternateFoodIndex);
          Navigator.of(context).pop();
          setState(() {});
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        // const PopupMenuItem<Menu>(
        //   value: Menu.itemOne,
        //   child: Text('Edit'),
        // ),
        const PopupMenuItem<Menu>(
          value: Menu.itemTwo,
          child: Text('Delete'),
        ),
      ],
    );
  }

  void showAlternateFoodDialog(List<GetDish> alternateFood, int dishIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.95,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Alternate Food",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: alternateFood.length,
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${alternateFood[index].dishId!.name}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              'Quantity : ${alternateFood[index].quantity} ${alternateFood[index].unit}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (widget.isEdit) popupMenu(dishIndex, index),
                    ],
                  ),
                ),
              ),
              const Divider(),
              if (widget.isEdit)
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const AddFoodScreen();
                          },
                        ),
                      ).then((dish) {
                        if (dish == null) {
                          return;
                        }
                      });
                      Navigator.of(context).pop();
                      pushAddAlternateDish(dishIndex);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Alternate food"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
