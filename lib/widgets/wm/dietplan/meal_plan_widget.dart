import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/wm/create_diet_plan_models.dart';
import 'package:healthonify_mobile/screens/client_screens/add_food_screen.dart';
import 'package:healthonify_mobile/widgets/wm/dietplan/diet_plan_meal_widget.dart';

class MealPlanWidget extends StatefulWidget {
  final Meal meal;
  final int mealIndex;
  final Function onDishAdd;
  final Function deleteMeal;
  const MealPlanWidget({
    required this.meal,
    required this.mealIndex,
    required this.onDishAdd,
    required this.deleteMeal,
    Key? key,
  }) : super(key: key);

  @override
  State<MealPlanWidget> createState() => _MealPlanWidgetState();
}

class _MealPlanWidgetState extends State<MealPlanWidget> {
  TimeOfDay? _selectedTime;
  double totalCalories = 0;
  double protiens = 0, carbs = 0, fats = 0, fibers = 0;

  @override
  void initState() {
    super.initState();
    if (widget.meal.dishes != null) {
      calculateCalories();
    }
  }

  void calculateCalories() {
    totalCalories = 0;
    protiens = 0;
    carbs = 0;
    fats = 0;
    fibers = 0;
    for (var ele in widget.meal.dishes!) {
      var tempQuantity = ele.quantity;
      var baseCalories = ele.perUnit!.calories;
      totalCalories = totalCalories + tempQuantity! * baseCalories!;

      protiens = double.parse(
          (protiens + (ele.nutrition![0].proteins!.quantity! * tempQuantity))
              .toStringAsFixed(3));

      carbs = double.parse(
          (carbs + (ele.nutrition![0].carbs!.quantity! * tempQuantity))
              .toStringAsFixed(3));
      fats = double.parse(
          (fats + (ele.nutrition![0].fats!.quantity! * tempQuantity))
              .toStringAsFixed(3));
      fibers = double.parse(
          (fibers + (ele.nutrition![0].fiber!.quantity! * tempQuantity))
              .toStringAsFixed(3));
    }

    log("called inside calorie card");
  }

  void onAddFood() {
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
      if (widget.meal.dishes != null) {
        widget.meal.dishes!.add(tempDish);
      } else {
        widget.meal.dishes ??= [tempDish];
      }
      calculateCalories.call();
      widget.onDishAdd.call();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[800]!,
            width: 0.8,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                // color: Color.fromARGB(255, 34, 34, 34),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Text(widget.meal.mealName ?? ""),
                  const SizedBox(width: 8),
                  Text(widget.meal.mealTime ?? ""),
                  const SizedBox(width: 8),
                  Text("($totalCalories kcal)"),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      showEditSheet(context);
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 24,
                      color: Colors.grey[700],
                    ),
                    splashRadius: 25,
                  ),
                  IconButton(
                    onPressed: () {
                      widget.deleteMeal();
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      size: 24,
                      color: Colors.grey[700],
                    ),
                    splashRadius: 25,
                  ),
                ],
              ),
            ),
            DietPlanMealWidget(
              dishes: widget.meal.dishes ?? [],
              carbs: carbs,
              fats: fats,
              fiber: fibers,
              proteins: protiens,
              updateCalories: () {
                calculateCalories();
                widget.onDishAdd.call();
                setState(() {});
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextButton.icon(
                onPressed: () {
                  onAddFood();
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Food'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEditSheet(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Change meal info',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                      size: 28,
                    ),
                    splashRadius: 20,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: TextFormField(
                  initialValue: widget.meal.mealName,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFC3CAD9),
                      ),
                    ),
                    constraints: const BoxConstraints(
                      maxHeight: 50,
                    ),
                    hintText: 'Meal name',
                    hintStyle: const TextStyle(
                      color: Color(0xFF959EAD),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onChanged: (value) {
                    widget.meal.mealName = value;
                    widget.meal.mealName = value;
                  },
                  validator: (value) {
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StatefulBuilder(
                  builder: (context, newState) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          _selectedTime == null
                              ? TimeOfDay.now().format(context)
                              : _selectedTime!.format(context),
                          style: Theme.of(context).textTheme.bodyMedium!),
                      TextButton(
                        onPressed: () {
                          _timePicker(newState);
                        },
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_selectedTime != null) {
                    // log(_selectedTime.toString());
                    String dateTime = DateFormat.jm().format(DateTime(
                      2000,
                      1,
                      1,
                      _selectedTime!.hour,
                      _selectedTime!.minute,
                    ));
                    widget.meal.mealTime = dateTime;
                  }

                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _timePicker(StateSetter thisState) {
    showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: customTimePickerTheme,
          child: child!,
        );
      },
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      thisState(() {
        _selectedTime = value;
      });
    });
  }

  Widget caloriesCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.22,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0.8,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Calories consumed',
                      style: Theme.of(context).textTheme.labelMedium),
                  Text('100 kCal',
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
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text('Protiens',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          '25 gms',
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
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text('Carbs',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          '25 gms',
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
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text('Fats',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          '25 gms',
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
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text('Fibers',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          '25 gms',
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
    );
  }
}
