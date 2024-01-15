import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/alert_dialog.dart';
import 'package:healthonify_mobile/func/diet/diet_func.dart';
import 'package:healthonify_mobile/models/user.dart';
import 'package:healthonify_mobile/models/wm/diet_plan_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/diet_plan_provider.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/diet/my_diet_plans/expert_diet_meal_plan/view_daily_diet_plan.dart';
import 'package:healthonify_mobile/widgets/buttons/customappbar_action_btns.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class ViewDietMealPlan extends StatefulWidget {
  final DietPlan dietPlan;
  final bool isEdit;
  final bool isEditEnabled;
  final bool? isFromMain;

  const ViewDietMealPlan({
    Key? key,
    required this.dietPlan,
    this.isEdit = false,
    this.isFromMain,
    this.isEditEnabled = true,
  }) : super(key: key);

  @override
  State<ViewDietMealPlan> createState() => _ViewDietMealPlanState();
}

class _ViewDietMealPlanState extends State<ViewDietMealPlan> {
  final _formKey = GlobalKey<FormState>();
  late List<RegularDetail> dietDays;
  bool isEdit = false;
  double proteins = 0.0,
      carbs = 0.0,
      fats = 0.0,
      fibers = 0.0,
      totalCalories = 0.0;

  bool isEditTextEnabled = false;

  void onEditClick() async {
    setState(() {
      isEdit = !isEdit;
    });
    if (isEdit == false) {
      log("on saved");
      await updateApi();
    }
  }

  void saveDietPlanName(String value) => widget.dietPlan.name = value;

  void saveTotalDietDays(String value) =>
      widget.dietPlan.validity = int.parse(value);

  void saveNote(String value) => widget.dietPlan.note = value;

  Future<void> updateApi() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    DietFunc().updateWorkoutPlan(context,
        dietPlanModel: widget.dietPlan, dietDays: dietDays);
  }

  String? userId;

  @override
  void initState() {
    super.initState();
    // log("len ${json.encode(widget.dietPlan.dietJson())}");
    userId = Provider.of<UserData>(context, listen: false).userData.id;
    dietDays = widget.dietPlan.weeklyDetails!;
    calculate();
    isEdit = widget.isEdit;
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
            onPressed: !widget.isEditEnabled
                ? () {
                    Navigator.of(context).pop();
                  }
                : () {
                    showDialog(
                      context: context,
                      builder: (context) => const CustomAlertDialog(
                        title: "Are you sure you want to go back?",
                        subtitle: "Any unsaved plans will be deleted",
                      ),
                    );
                  },
          ),
          appBarTitle: widget.dietPlan.name ?? "",
          widgetRight: widget.isEditEnabled
              ? CustomAppBarTextBtn(
                  onClick: () {
                    onEditClick();
                  },
                  title: isEdit ? "Save Plan" : "Edit Plan")
              : const SizedBox()),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _textFieldBuilder(context,
                        onSaved: saveDietPlanName,
                        hint:
                            "Diet plan name eg fatloss plan, weight gain plan",
                        initValue: widget.dietPlan.name!,
                        title: "Diet Plan Name"),
                    _textFieldBuilder(context,
                        textInputType: TextInputType.number,
                        onSaved: saveTotalDietDays,
                        hint: "Total Diet Days",
                        initValue: widget.dietPlan.validity.toString(),
                        title: "Total Diet Days"),
                    _textFieldBuilder(
                      context,
                      initValue: widget.dietPlan.note!,
                      onSaved: saveNote,
                      hint: "Add Note ",
                      title: "Add a note",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    _daysCard(),
                  ],
                ),
              ),
            ),
          ),
          widget.isFromMain == true ?
              const SizedBox() :
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            color: whiteColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> payload = {
                        "userId": userId,
                        "dietPlanId": widget.dietPlan.id
                      };
                      await Provider.of<DietPlanProvider>(context,
                              listen: false)
                          .addDietPlan(payload)
                          .then((value) {
                        Navigator.pop(context);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      color: Theme.of(context).colorScheme.primary,
                      child: Center(
                        child: Text(
                          "Add To My Diet Plan",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: whiteColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
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
      if (dietDay.meals != null || dietDay.meals!.isNotEmpty) {
        for (var meal in dietDay.meals!) {
          if (meal.dishes == null) {
            continue;
          }
          for (var ele in meal.dishes!) {
            if (ele.dishId != null) {
              var tempQuantity = ele.quantity;
              var baseCalories = ele.dishId!.perUnit!.calories;
              totalCalories = totalCalories + tempQuantity! * baseCalories!;

              proteins = proteins +
                  (ele.dishId!.nutrition![0].proteins!.quantity! *
                      tempQuantity);
              carbs = carbs +
                  (ele.dishId!.nutrition![0].carbs!.quantity! * tempQuantity);
              fats = fats +
                  (ele.dishId!.nutrition![0].fats!.quantity! * tempQuantity);
              fibers = fibers +
                  (ele.dishId!.nutrition![0].fiber!.quantity! * tempQuantity);
            }
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

  Widget _textFieldBuilder(
    BuildContext context, {
    required Function onSaved,
    required String title,
    required String hint,
    required String initValue,
    TextInputType textInputType = TextInputType.name,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  enabled: isEdit,
                  keyboardType: textInputType,
                  initialValue: initValue,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    suffixIcon: !isEdit
                        ? const SizedBox()
                        : Icon(Icons.edit,
                            color: Theme.of(context).colorScheme.secondary),
                    hintText: hint,
                  ),
                  onSaved: (newValue) => onSaved(newValue),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field cannot be empty";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
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
                      "Note",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    if (isEdit) const Icon(Icons.edit),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(widget.dietPlan.note!),
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
        ),
      ),
    );
  }

  Widget _day({String? title, String? subtitle, required int index}) {
    return InkWell(
      onTap: () {
        // log("meals len ${dietDays[index].meal![0].dishes!.length}");

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewDietDietPlan(
              mealsList: dietDays[index].meals ?? [],
              deleteMeal: () {},
              isEdit: isEdit,
              title: title!,
            ),
          ),
        );
        //     .then((meals) {
        //   if (meals == null || meals.isEmpty) {
        //     log("meal is null/ empty");
        //     return;
        //   }
        //   log("meal isn't empty");
        //   List<Meal> mealsData = meals;
        //   dietDays[index].meal = mealsData;
        //   // log("meals len ${dietDays[index].meal![0].dishes![0].n}");
        //   // for (var meal in dietDays[index].meal!) {
        //   //   log("oops");
        //   //   for (var dish in meal.dishes!) {
        //   //     log("dish name ${dish.name!}");
        //   //   }
        //   // }

        //   calculate();
        //   setState(() {});
        // });
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
