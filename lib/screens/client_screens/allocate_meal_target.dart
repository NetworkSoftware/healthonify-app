import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/providers/fitness_tools/fitness_tools_data.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/trackers/calorie_tracker_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/weight_management/meal_plans_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:provider/provider.dart';

class AllocateMealTarget extends StatefulWidget {
  final Map<String, dynamic> calorieData;
  const AllocateMealTarget({required this.calorieData, Key? key})
      : super(key: key);

  @override
  State<AllocateMealTarget> createState() => _AllocateMealTargetState();
}

class _AllocateMealTargetState extends State<AllocateMealTarget> {
  Map<String, dynamic> calorieMap = {};

  @override
  void initState() {
    super.initState();

    calorieMap = {
      "set": {
        "calorieIntake": widget.calorieData["calorieCount"],
        "mealCaloriesGoal": {
          "breakfastGoal": widget.calorieData['breakfastCount'],
          "lunchGoal": widget.calorieData['lunchCount'],
          "dinnerGoal": widget.calorieData['dinnerCount'],
          "morningSnacksGoal": widget.calorieData['morningSnacksCount'],
          "afternoonSnacksGoal": widget.calorieData['afternoonSnacksCount'],
        },
      },
    };
  }

  void updateLocal() {
    Provider.of<AllTrackersData>(context, listen: false)
        .localUpdateCalories(int.parse(widget.calorieData["calorieCount"]));
    Provider.of<CalorieTrackerProvider>(context, listen: false)
        .updateBaseGoal(widget.calorieData["calorieCount"]);
  }

  Future<void> updateMealTargets() async {
    SharedPrefManager pref = SharedPrefManager();

    String userId = Provider.of<UserData>(context, listen: false).userData.id ??
        await pref.getUserID();

    try {
      await Provider.of<FitnessToolsData>(context, listen: false)
          .setMealTargets(calorieMap, userId);
      updateLocal.call();
      Fluttertoast.showToast(msg: 'Meal Targets set');
      popFunc();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to set meal targets');
    }
  }

  void popFunc() {
    // Navigator.pop(context);
    // Navigator.pop(context);
    // Navigator.pop(context);
    // Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MealPlansScreen()));
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
    //   return const MainScreen();
    // }), (Route<dynamic> route) => false);
  }

  void onSubmit() {
    updateMealTargets();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.calorieData.toString());

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Allocate Meal Target',
            style: Theme.of(context).textTheme.headlineMedium,
          )),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  'Daily Calorie intake : ${widget.calorieData['goalCalories']} kCal',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Breakfast",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    widget.calorieData['breakfastCount'] + " " + "Kcal",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Morning Snack",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    widget.calorieData['morningSnacksCount'] + " " + "Kcal",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Lunch",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    widget.calorieData['lunchCount'] + " " + "Kcal",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Evening Snack",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    widget.calorieData['afternoonSnacksCount'] + " " + "Kcal",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dinner",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    widget.calorieData['dinnerCount'] + " " + "Kcal",
                  ),
                ],
              ),
            ),
            // const Spacer(),
            // Padding(
            //   padding: const EdgeInsets.only(left: 16),
            //   child: Text(
            //     'Allocate -',
            //     style: Theme.of(context).textTheme.labelMedium,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: ListView.builder(
            //     physics: const BouncingScrollPhysics(),
            //     shrinkWrap: true,
            //     itemCount: 5,
            //     itemBuilder: (context, index) {
            //       return allocateMealCal(
            //         context,
            //         meals[index],
            //         "200 kCal",
            //         index,
            //       );
            //     },
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 10),
            //   child: TextButton(
            //     onPressed: () {},
            //     child: const Text('Add Meal'),
            //   ),
            // ),
            // const Spacer(flex: 2),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientButton(
                  title: 'Start Tracking Diet',
                  func: () {
                    log(calorieMap.toString());
                    onSubmit();
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return const MealPlansScreen();
                    // }));
                  },
                  gradient: orangeGradient,
                ),
              ],
            ),
            // ElevatedButton(
            //   onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return const MealPlansScreen();
            // }));
            //   },
            //   child: const Text('Start Tracking Diet'),
            // ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget allocateMealCal(context, String mealNames, String calories, index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            mealNames,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(calories),
          // TextFormField(
          //   keyboardType: TextInputType.phone,
          //   decoration: InputDecoration(
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(8),
          //       borderSide: const BorderSide(
          //         color: Color(0xFFC3CAD9),
          //       ),
          //     ),
          //     constraints: const BoxConstraints(
          //       maxHeight: 40,
          //       maxWidth: 90,
          //     ),
          //     hintText: 'Calories',
          //     hintStyle: const TextStyle(
          //       color: Color(0xFF959EAD),
          //       fontSize: 16,
          //       fontWeight: FontWeight.w500,
          //       fontFamily: 'OpenSans',
          //     ),
          //   ),
          //   onSaved: (value) {},
          //   validator: (value) {
          //     return null;
          //   },
          // ),
        ],
      ),
    );
  }
}
