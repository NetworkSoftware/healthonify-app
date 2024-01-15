import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/wm/create_diet_plan_models.dart';
import 'package:healthonify_mobile/screens/client_screens/add_food_screen.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class DietPlanMealWidget extends StatefulWidget {
  final List<CreateDietDish> dishes;
  final double? proteins, carbs, fats, fiber;
  final Function updateCalories;
  const DietPlanMealWidget({
    Key? key,
    required this.dishes,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.fiber,
    required this.updateCalories,
  }) : super(key: key);

  @override
  State<DietPlanMealWidget> createState() => _DietPlanMealWidgetState();
}

class _DietPlanMealWidgetState extends State<DietPlanMealWidget> {
  // @override
  // void initState() {
  //   super.initState();
  //   log(" dishes len ${widget.dishes.length}");
  // }

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
      if (widget.dishes[index].alternateFood != null) {
        widget.dishes[index].alternateFood!.add(tempDish);
      } else {
        widget.dishes[index].alternateFood ??= [tempDish];
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

  Widget foodLayout(CreateDietDish dish, int index) {
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
                  '${dish.name}',
                  style: Theme.of(context).textTheme.labelLarge,
                )),
                PopupMenuButton<Menu>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (Menu item) {
                    if (item == Menu.itemTwo) {
                      widget.dishes.removeAt(index);
                      widget.updateCalories();
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
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
                'Calories : ${dish.quantity! * dish.perUnit!.calories!} kcal  Quantity : ${dish.quantity} ${dish.unit}'),
          ],
        ),
        dish.alternateFood != null && dish.alternateFood!.isNotEmpty
            ? TextButton(
                onPressed: () {
                  showAlternateFoodDialog(dish.alternateFood!, index);
                },
                child: const Text("View  Alternate Food"),
              )
            : TextButton(
                onPressed: () {
                  pushAddAlternateDish(index);
                },
                child: const Text("Add Alternate Food"),
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
          setState(() {});
          Navigator.of(context).pop();
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

  void showAlternateFoodDialog(
      List<CreateDietDish> alternateFood, int dishIndex) {
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
                              '${alternateFood[index].name}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              'Quantity : ${alternateFood[index].quantity} ${alternateFood[index].unit}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      popupMenu(dishIndex, index),
                    ],
                  ),
                ),
              ),
              const Divider(),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return const AddFoodScreen();
                    //     },
                    //   ),
                    // ).then((dish) {
                    //   if (dish == null) {
                    //     return;
                    //   }

                    // });
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
