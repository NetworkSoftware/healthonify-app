// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/providers/trackers/calorie_tracker_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/allocate_meal_target.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/text%20fields/custom_text_field.dart';
import 'package:provider/provider.dart';

class CaloriesTargetScreen extends StatefulWidget {
  final Map<String, dynamic> calorieData;
  final bool isAfterLogin;
  const CaloriesTargetScreen(
      {required this.calorieData, Key? key, required this.isAfterLogin})
      : super(key: key);

  @override
  State<CaloriesTargetScreen> createState() => _CaloriesTargetScreenState();
}

class _CaloriesTargetScreenState extends State<CaloriesTargetScreen> {
  Map<String, dynamic> caloriesGoal = {
    "userId": "",
    "calorieIntake": "",
    "caloriesBurntGoal": "",
  };

  void onSubmit() async {
    log("calories data ${widget.calorieData}");
    SharedPrefManager pref = SharedPrefManager();
    String userId = await pref.getUserID();

    // caloriesGoal["date"] = DateFormat('yyyy-MM-dd').format(DateTime.now());
    caloriesGoal["userId"] = userId;
    caloriesGoal["calorieIntake"] =
        int.parse(widget.calorieData["calorieCount"]!);
    if (caloriesToBurn != null) {
      caloriesGoal["caloriesBurntGoal"] = int.parse(caloriesToBurn!);
    }

    log(caloriesGoal.toString());
    submitCaloriesGoal();
  }

  Future<void> submitCaloriesGoal() async {
    try {
      await Provider.of<CalorieTrackerProvider>(context, listen: false)
          .setCaloriesGoal(caloriesGoal);

      popFunction();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to allocate calorie goal');
    }
  }

  void popFunction() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return AllocateMealTarget(
        calorieData: widget.calorieData,
      );
    }));
  }

  @override
  void initState() {
    super.initState();
    log(widget.calorieData.toString());
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('dd MMM yyyy').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            '',
          )),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Image.asset(
                'assets/icons/target.png',
                height: 100,
                width: 100,
              ),
            ),
            Text(
              'Your daily calories target is set',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weight Plan',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        date,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        'Goal start date',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.calorieData["goalCalories"] ??
                                            "0",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                      Text(
                                        'Daily Calories budget',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 30),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.calorieData["targetWeight"] ==
                                                null
                                            ? "0 kg"
                                            : "${widget.calorieData["targetWeight"]} kg",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                      Text(
                                        'Target weight',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.calorieData["currentWeight"] == null
                                    ? "0 kg"
                                    : "${widget.calorieData["currentWeight"]} kg",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                'Current weight',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 10),

                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Text(
                              //   '-',
                              //   style: Theme.of(context).textTheme.labelMedium,
                              // ),
                              // Text(
                              //   'Total weight gain',
                              //   style: Theme.of(context).textTheme.bodySmall,
                              // ),
                            ],
                          ),
                          // Column(
                          //   mainAxisAlignment: MainAxisAlignment.end,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       '-',
                          //       style: Theme.of(context).textTheme.labelMedium,
                          //     ),
                          //     Text(
                          //       'Number of days',
                          //       style: Theme.of(context).textTheme.bodySmall,
                          //     ),
                          //     const SizedBox(
                          //       height: 10,
                          //     ),
                          //     Text(
                          //       calorieData!.targetWeight! + " kg",
                          //       style: Theme.of(context).textTheme.labelMedium,
                          //     ),
                          //     Text(
                          //       'Target weight',
                          //       style: Theme.of(context).textTheme.bodySmall,
                          //     ),
                          //     const SizedBox(
                          //       height: 10,
                          //     ),
                          //     Text(
                          //       '-',
                          //       style: Theme.of(context).textTheme.labelMedium,
                          //     ),
                          //     Text(
                          //       'Weekly weight gain',
                          //       style: Theme.of(context).textTheme.bodySmall,
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (widget.isAfterLogin)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Note-To lose healthy weight of 0.5 kg to 1kg per week you should have a calorie burn of 500 to 1000 calories per day",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            !widget.isAfterLogin
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientButton(
                        title: 'Allocate Meal Target',
                        func: () {
                          // inputCaloriesBurnt(context);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return AllocateMealTarget(
                              calorieData: widget.calorieData,
                            );
                          }));
                        },
                        gradient: orangeGradient,
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientButton(
                        title: 'Allocate Goal',
                        func: () {
                          inputCaloriesBurnt(context);
                        },
                        gradient: orangeGradient,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  String? caloriesToBurn = "800";

  void inputCaloriesBurnt(context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Input the number of Calories you want to burn',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  initialValue: "800",
                  keyboard: TextInputType.phone,
                  hint: 'Calories to burn',
                  hintBorderColor: Colors.grey,
                  onChanged: (value) {
                    caloriesToBurn = value;
                  },
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    if (caloriesToBurn == null) {
                      Fluttertoast.showToast(
                          msg:
                              'Please enter the number of calories you want to burn');
                      return;
                    }
                    onSubmit();
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
