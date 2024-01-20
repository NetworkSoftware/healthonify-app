
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/diet/diet_log_func.dart';
import 'package:healthonify_mobile/func/diet/meals_switch_case.dart';
import 'package:healthonify_mobile/models/wm/create_diet_plan_models.dart';
import 'package:healthonify_mobile/models/wm/diet_plan_model.dart';
import 'package:healthonify_mobile/models/wm/dish_model.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/trackers/calorie_tracker_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/add_food_screen.dart';
import 'package:healthonify_mobile/widgets/wm/viewdietplan/view_diet_plan_meal_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewMealDietLogWidget extends StatefulWidget {
  final GetMeal meal;
  final int mealIndex;
  final String date;
  final Function onDishAdd;
  final Function deleteMeal;
  const ViewMealDietLogWidget({
    required this.meal,
    required this.mealIndex,
    required this.onDishAdd,
    required this.date,
    required this.deleteMeal,
    Key? key,
  }) : super(key: key);

  @override
  State<ViewMealDietLogWidget> createState() => _ViewMealDietLogWidgetState();
}

class _ViewMealDietLogWidgetState extends State<ViewMealDietLogWidget> {
  TimeOfDay? _selectedTime;
  double totalCalories = 0;
  double protiens = 0, carbs = 0, fats = 0, fibers = 0;

  @override
  void initState() {
    super.initState();
    if (widget.meal.dishes != null && widget.meal.dishes!.isNotEmpty) {
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
      var baseCalories = ele.dishId!.perUnit!.calories;

      totalCalories = totalCalories + tempQuantity! * baseCalories!;
      protiens = 0.0;
      fibers = 0.0;
      fats = 0.0;
      carbs = 0.0;
      // protiens = double.parse((protiens +
      //         (ele.dishId!.nutrition![0].proteins!.quantity! * tempQuantity))
      //     .toStringAsPrecision(3));
      // carbs = double.parse(
      //     (carbs + (ele.dishId!.nutrition![0].carbs!.quantity! * tempQuantity))
      //         .toStringAsPrecision(3));
      //
      // fats = double.parse(
      //     (fats + (ele.dishId!.nutrition![0].fats!.quantity! * tempQuantity))
      //         .toStringAsPrecision(3));
      // fibers = double.parse(
      //     (fibers + (ele.dishId!.nutrition![0].fiber!.quantity! * tempQuantity))
      //         .toStringAsPrecision(3));
    }

    //this is to update local calories

    String today = DateFormat("yyyy/MM/dd").format(DateTime.now());
    if (today == widget.date) {
      Future.delayed(Duration.zero, () {
        var mealName = MealSwitchCase().upperToLower(widget.meal.mealName!);
        Provider.of<AllTrackersData>(context, listen: false)
            .localUpdateMealCalories(totalCalories.round(), mealName);
      });
    }
  }

  void onDeleteFood() async {
    calculateCalories();

    widget.onDishAdd.call();
    await DietLogFunc().postDietLog(context, widget.meal, widget.date);

    setState(() {});
  }

  void onAddFood() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const AddFoodScreen();
        },
      ),
    ).then((dish) async {
      if (dish == null) {
        return;
      }
      CreateDietDish tempDish = dish;

      if (tempDish.quantity! > 20) {
        Fluttertoast.showToast(msg: 'Please enter a valid quantity');
        return;
      }
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
                id: nutr.id,
              );
            },
          ),
          perUnit: GetPerUnit(
            calories: tempDish.perUnit!.calories,
            quantity: tempDish.perUnit!.quantity,
            weight: tempDish.perUnit!.weight.toString(),
          ),
        ),
        quantity: double.parse("${tempDish.quantity}"),
        unit: tempDish.unit,
      );
      if (widget.meal.dishes != null) {
        widget.meal.dishes!.add(tempAltDish);
      } else {
        widget.meal.dishes ??= [tempAltDish];
      }
      calculateCalories.call();
      widget.onDishAdd.call();

      await DietLogFunc().postDietLog(context, widget.meal, widget.date);
      setState(() {});
    });
  }

  void updateCaloriesTracker(double value) {
    Provider.of<CalorieTrackerProvider>(context, listen: false)
        .updateCaloriesTrackerConsumption(value.toString());
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
              constraints: const BoxConstraints(minHeight: 54),
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
                  // Text(widget.meal.mealTime ?? ""),
                  // const SizedBox(width: 8),
                  Text("(${totalCalories.toStringAsFixed(2)} kcal)"),
                  const Spacer(),
                  // IconButton(
                  //   onPressed: () {
                  //     showEditSheet(context);
                  //   },
                  //   icon: Icon(
                  //     Icons.edit_outlined,
                  //     size: 24,
                  //     color: Colors.grey[700],
                  //   ),
                  //   splashRadius: 25,
                  // ),
                  // IconButton(
                  //   onPressed: () {
                  //     widget.deleteMeal();
                  //   },
                  //   icon: Icon(
                  //     Icons.delete_outline,
                  //     size: 24,
                  //     color: Colors.grey[700],
                  //   ),
                  //   splashRadius: 25,
                  // ),
                ],
              ),
            ),
            ViewDietPlanMealWidget(
              dishes: widget.meal.dishes ?? [],
              carbs: carbs,
              fats: fats,
              fiber: fibers,
              proteins: protiens,
              isEdit: true,
              isLog: true,
              calculateCalories: onDeleteFood,
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
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child: StatefulBuilder(
              //     builder: (context, newState) => Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       children: [
              //         Text(
              //             _selectedTime == null
              //                 ? TimeOfDay.now().format(context)
              //                 : _selectedTime!.format(context),
              //             style: Theme.of(context).textTheme.bodyMedium!),
              //         TextButton(
              //           onPressed: () {
              //             _timePicker(newState);
              //           },
              //           child: const Text('Edit'),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              ElevatedButton(
                onPressed: () {
                  // if (_selectedTime != null) {
                  //   // log(_selectedTime.toString());
                  //   String dateTime = DateFormat.jm().format(DateTime(
                  //     2000,
                  //     1,
                  //     1,
                  //     _selectedTime!.hour,
                  //     _selectedTime!.minute,
                  //   ));
                  //   widget.meal.mealTime = dateTime;
                  // }

                  DietLogFunc().postDietLog(context, widget.meal, widget.date);
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
}
