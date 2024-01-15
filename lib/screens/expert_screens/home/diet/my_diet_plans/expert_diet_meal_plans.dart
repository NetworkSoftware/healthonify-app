import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/days_list.dart';
import 'package:healthonify_mobile/func/alert_dialog.dart';
import 'package:healthonify_mobile/func/diet/diet_func.dart';
import 'package:healthonify_mobile/models/wm/create_diet_plan_models.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/expert_daily_diet_plan.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/my_diet_plans_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/customappbar_action_btns.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class ExpertDietMealPlans extends StatefulWidget {
  final String title;
  final bool isAssignPlan;
  final CreateDietPlanModel createDietPlanModel;
  const ExpertDietMealPlans({
    Key? key,
    required this.title,
    this.isAssignPlan = true,
    required this.createDietPlanModel,
  }) : super(key: key);

  @override
  State<ExpertDietMealPlans> createState() => _ExpertDietMealPlansState();
}

class _ExpertDietMealPlansState extends State<ExpertDietMealPlans> {
  late List<CreateDietDays> dietDays;
  double proteins = 0.0,
      carbs = 0.0,
      fats = 0.0,
      fibers = 0.0,
      totalCalories = 0.0;

  @override
  void initState() {
    super.initState();
    dietDays = List.generate(
      7,
      (index) => CreateDietDays(
        day: days[index],
        meal: [],
      ),
    );
  }

  void popScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MyDietPlans()),
        (Route<dynamic> route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const CustomAlertDialog(
                title: "Are you sure you want to go back?",
                subtitle: "The chosen plan will be removed!!!",
              ),
            );
          },
        ),
        appBarTitle: widget.title,
        widgetRight: widget.isAssignPlan
            ? CustomAppBarTextBtn(
                onClick: () async {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => SelectClientList()));
                  widget.createDietPlanModel.dietDaysDetails = dietDays;
                  bool value = await DietFunc().postDietFunc(context,
                      dietPlanModel: widget.createDietPlanModel,
                      dietDays: dietDays);

                  if (value == true) {
                    Fluttertoast.showToast(msg: "Diet Plan saved");
                    popScreen();
                  }
                },
                title: "Create Plan")
            : const Text(""),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // editNotesCard(),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 12),
            //   child: CaloriesMealCard(
            //     proteins: proteins,
            //     carbs: carbs,
            //     fats: fats,
            //     fiber: fibers,
            //     totalCalories: totalCalories,
            //   ),
            // ),
            _daysCard(),
          ],
        ),
      ),
    );
  }

  void calculate() {
    proteins = 0.0;
    carbs = 0.0;
    fats = 0.0;
    fibers = 0.0;
    totalCalories = 0.0;
    for (var dietDay in dietDays) {
      if (dietDay.meal != null || dietDay.meal!.isNotEmpty) {
        for (var meal in dietDay.meal!) {
          if (meal.dishes == null) {
            continue;
          }
          for (var ele in meal.dishes!) {
            var tempQuantity = ele.quantity;
            var baseCalories = ele.perUnit!.calories;
            totalCalories = totalCalories + tempQuantity! * baseCalories!;

            proteins = proteins +
                (ele.nutrition![0].proteins!.quantity! * tempQuantity);
            carbs = carbs + (ele.nutrition![0].carbs!.quantity! * tempQuantity);
            fats = fats + (ele.nutrition![0].fats!.quantity! * tempQuantity);
            fibers =
                fibers + (ele.nutrition![0].fiber!.quantity! * tempQuantity);
          }
        }
      }
    }
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

  Widget editNotesCard() {
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
                    const Icon(Icons.edit),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _daysCard() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dietDays.length,
            itemBuilder: (context, index) => _day(
                title: dietDays[index].day,
                subtitle: "Calories: 0 kcal",
                index: index),
          ),
          //  Column(
          //   children: [
          //     _day(title: "Monday", subtitle: "Calories: 0 kcal", index: 0),
          //     _day(title: "Tuesday", subtitle: "Calories: 0 kcal", index: 1),
          //     _day(title: "Wednesday", subtitle: "Calories: 0 kcal", index: 2),
          //     _day(title: "Thursday", subtitle: "Calories: 0 kcal", index: 3),
          //     _day(title: "Friday", subtitle: "Calories: 0 kcal", index: 4),
          //     _day(title: "Saturday", subtitle: "Calories: 0 kcal", index: 5),
          //     _day(title: "Sunday", subtitle: "Calories: 0 kcal", index: 6),
          //   ],
          // ),
        ),
      ),
    );
  }

  Widget _day({String? title, String? subtitle, required int index}) {
    return InkWell(
      onTap: () {
        // log("meals len ${dietDays[index].meal![0].dishes!.length}");

        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => ExpertDailyDietPlan(
                title: widget.title,
                mealsList: dietDays[index].meal!,
                deleteMeal: () {}),
          ),
        )
            .then((meals) {
          if (meals == null || meals.isEmpty) {
            log("meal is null/ empty");
            return;
          }
          log("meal isn't empty");
          List<Meal> mealsData = meals;
          dietDays[index].meal = mealsData;
          // log("meals len ${dietDays[index].meal![0].dishes![0].n}");
          // for (var meal in dietDays[index].meal!) {
          //   log("oops");
          //   for (var dish in meal.dishes!) {
          //     log("dish name ${dish.name!}");
          //   }
          // }

          calculate();
          setState(() {});
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title!),
                // const Text("Calories: 0 kcal"),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
