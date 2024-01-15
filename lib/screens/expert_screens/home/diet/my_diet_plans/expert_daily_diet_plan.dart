import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/wm/create_diet_plan_models.dart';
import 'package:healthonify_mobile/widgets/buttons/customappbar_action_btns.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/experts/dietplans/edit_meal_btmsheet.dart';
import 'package:healthonify_mobile/widgets/wm/dietplan/calories_meal_card.dart';
import 'package:healthonify_mobile/widgets/wm/dietplan/meal_plan_widget.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class ExpertDailyDietPlan extends StatefulWidget {
  final String title;
  final List<Meal> mealsList;
  final Function deleteMeal;
  const ExpertDailyDietPlan({
    Key? key,
    required this.title,
    required this.mealsList,
    required this.deleteMeal,
  }) : super(key: key);

  @override
  State<ExpertDailyDietPlan> createState() => _ExpertDailyDietPlanState();
}

class _ExpertDailyDietPlanState extends State<ExpertDailyDietPlan> {
  List<Meal> meals = [];
  double totalCalories = 0;
  double protiens = 0, carbs = 0, fats = 0, fibers = 0;
  @override
  void initState() {
    super.initState();
    if (widget.mealsList.isEmpty) {
      meals = List.generate(
        1,
        (index) => Meal(
          mealName: "Meal ${index + 1}",
          mealTime: "09:00 AM",
          dishes: [],
        ),
      );
    } else {
      // log("dis len ${widget.mealsList[0].dishes!.length}");
      meals = widget.mealsList;
      calculateCalories();
    }
  }

  void calculateCalories() {
    totalCalories = 0;
    protiens = 0;
    carbs = 0;
    fats = 0;
    fibers = 0;
    for (var ele1 in meals) {
      if (ele1.dishes == null) {
        // log("1");
        continue;
      }
      for (var ele in ele1.dishes!) {
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

        log("called outside calorie card");
      }
    }
  }

  void deleteMeal(int index) {
    meals.removeAt(index);
    calculateCalories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: widget.title,
        widgetRight: CustomAppBarTextBtn(
          title: "Add To Day",
          onClick: () async {
            Navigator.of(context).pop(meals);
          },
        ),
        // leading: IconButton(
        //   onPressed: () {},
        //   icon: const Icon(Icons.arrow_back_ios),
        // ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // _editNotesCard(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: CaloriesMealCard(
                showGoal: false,
                carbs: carbs,
                fats: fats,
                fiber: fibers,
                proteins: protiens,
                totalCalories: totalCalories,
              ),
            ),

            ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  return MealPlanWidget(
                    meal: meals[index],
                    mealIndex: index,
                    onDishAdd: () {
                      calculateCalories();
                      setState(() {});
                    },
                    deleteMeal: () {
                      deleteMeal(index);
                    },
                    // mealDetails: addedMeal(context),
                  );
                }),
            AddMealBtmSheet(addMeal: (mealName, selectedTime) {
              meals.add(
                Meal(
                  mealName: mealName,
                  mealTime: selectedTime,
                  dishes: [],
                ),
              );
              setState(() {});
            }),
          ],
        ),
      ),
    );
  }

  void editDietPlanNote() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Text(
                      'Plan Note',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
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
                  ),
                ],
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: TextField(
                    decoration: InputDecoration(hintText: "Enter Note"),
                  )),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _editNotesCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      child: Card(
        child: InkWell(
          onTap: () {
            editDietPlanNote();
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Notes",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const Icon(Icons.add),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("No note found"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget popupMenu() {
    return PopupMenuButton<Menu>(
      icon: const Icon(Icons.more_vert),
      onSelected: (Menu item) {
        setState(() {});
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
        const PopupMenuItem<Menu>(
          value: Menu.itemOne,
          child: Text('Edit'),
        ),
        const PopupMenuItem<Menu>(
          value: Menu.itemTwo,
          child: Text('Delete'),
        ),
      ],
    );
  }

  void showBtmSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const EditMealBtmSheet();
      },
    );
  }
}

class AddMealBtmSheet extends StatefulWidget {
  final Function addMeal;
  const AddMealBtmSheet({
    Key? key,
    required this.addMeal,
  }) : super(key: key);

  @override
  State<AddMealBtmSheet> createState() => _AddMealBtmSheetState();
}

class _AddMealBtmSheetState extends State<AddMealBtmSheet> {
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        child: InkWell(
          onTap: () {
            addMeal();
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add Meal",
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: whiteColor),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.add_circle,
                  color: whiteColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addMeal() {
    String mealName = "", time = "";
    showBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Text(
                      'Add Meal',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
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
                  ),
                ],
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: TextField(
                    decoration: const InputDecoration(
                        hintText: "Meal name eg breakfast, morning snack etc"),
                    onChanged: (value) => mealName = value,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StatefulBuilder(
                  builder: (context, newState) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          _selectedTime == null
                              ? "Select a time"
                              : _selectedTime!.format(context),
                          style: Theme.of(context).textTheme.bodyMedium!),
                      TextButton(
                        onPressed: () {
                          _timePicker(newState);
                        },
                        child: _selectedTime == null
                            ? const Text('Select')
                            : const Text('Edit'),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (mealName.isEmpty) {
                    Fluttertoast.showToast(msg: "Please enter a meal name");
                    return;
                  }
                  if (_selectedTime == null) {
                    // log(_selectedTime.toString());
                    Fluttertoast.showToast(
                        msg: "Please enter a time for the meal");
                    return;
                  }
                  String dateTime = DateFormat.jm().format(DateTime(
                    2000,
                    1,
                    1,
                    _selectedTime!.hour,
                    _selectedTime!.minute,
                  ));
                  widget.addMeal(mealName, dateTime);
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
