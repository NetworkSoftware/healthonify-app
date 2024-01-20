import 'dart:developer';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/diet/diet_log_func.dart';
import 'package:healthonify_mobile/func/diet/meals_switch_case.dart';
import 'package:healthonify_mobile/models/wm/diet_log_model.dart';
import 'package:healthonify_mobile/models/wm/diet_plan_model.dart';
import 'package:healthonify_mobile/providers/trackers/calorie_tracker_provider.dart';
import 'package:healthonify_mobile/providers/weight_management/diet_log_provider.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/calendar_appbar.dart';
import 'package:healthonify_mobile/widgets/wm/diet_log.dart/view_meal_diet_log.dart';
import 'package:healthonify_mobile/widgets/wm/dietplan/calories_meal_card.dart';
import 'package:provider/provider.dart';

class MealPlansScreen extends StatefulWidget {
  final bool isWm;
  final String mealName;
  const MealPlansScreen({
    Key? key,
    this.isWm = false,
    this.mealName = "",
  }) : super(key: key);

  @override
  State<MealPlansScreen> createState() => _MealPlansScreenState();
}

class _MealPlansScreenState extends State<MealPlansScreen> {
  TimeOfDay? _selectedTime;
  bool isMainLoading = false;
  bool isWidgetloading = false;
  List<DietLog> dietLog = [];
  Function? widgetState;
  double totalCalories = 0;
  double protiens = 0, carbs = 0, fats = 0, fibers = 0;

  late String currentDate;
  Future<void> getDietLogs(String date) async {
    currentDate = date;
    setState(() {
      isMainLoading = true;
    });
    await DietLogFunc().getDietLogs(context, date: date);
    setState(() {
      isMainLoading = false;
    });
  }

  Future<void> getDietLogsState(String date) async {
    currentDate = date;
    widgetState!(() {
      isWidgetloading = true;
    });
    await DietLogFunc().getDietLogs(context, date: date);
    widgetState!(() {
      isWidgetloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat("yyyy/MM/dd").format(DateTime.now());
    getDietLogs(DateFormat("yyyy/MM/dd").format(
      DateTime.now(),
    ));
  }

  void addDiet() {
    if (widget.isWm) {
      for (var element in dietLog) {
        if (element.mealName == widget.mealName) {
          return;
        }
      }
      dietLog.insert(
        0,
        DietLog(
          mealName: widget.mealName,
          dishes: [],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Log your food',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!widget.isWm)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: HorizCalendar(
                  function: (String date) {
                    getDietLogsState(date);
                  },
                ),
              ),
            isMainLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<DietLogProvider>(
                    builder: (context, value, child) {
                      dietLog = value.dietLog;

                      addDiet();
                      calculateCalories(); //issue with this
                      return StatefulBuilder(
                        builder: (context, setState) {
                          widgetState = setState;
                          return isWidgetloading
                              ? const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: CaloriesMealCard(
                                        showGoal: false,
                                        carbs: carbs,
                                        fats: fats,
                                        fiber: fibers,
                                        proteins: protiens,
                                        totalCalories: totalCalories,
                                      ),
                                    ),
                                    dietLog.isEmpty
                                        ? const Padding(
                                            padding: EdgeInsets.only(top: 8.0),
                                            child: Text("No log added"),
                                          )
                                        : ListView.builder(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: dietLog.length,
                                            itemBuilder: (context, index) {
                                              return ViewMealDietLogWidget(
                                                date: currentDate,
                                                mealIndex: 0,
                                                meal: GetMeal(
                                                    id: dietLog[index].id,
                                                    mealName: MealSwitchCase()
                                                        .lowerToUpper(
                                                            dietLog[index]
                                                                    .mealName ??
                                                                ""),
                                                    // mealTime: StringDateTimeFormat()
                                                    //     .convertTimeStampToTime(
                                                    //         dietLog[index]
                                                    //             .timeInMs!),
                                                    dishes:
                                                        dietLog[index].dishes ??
                                                            [],
                                                    mealOrder: index + 1),
                                                onDishAdd: () {
                                                  calculateCalories();
                                                },
                                                deleteMeal: () {},
                                              );
                                            }),
                                  ],
                                );
                        },
                      );
                    },
                  ),

            // const MealCard(),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: GradientButton2(
          title: 'Add Meal',
          func: () {
            addMealPopUp(context);
          },
          gradient: orangeGradient,
        ),
      ),
    );
  }

  // Widget addedMeals(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(6),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 child: Column(
  //                   children: [
  //                     Text(
  //                       '1.5 gms',
  //                       style: Theme.of(context).textTheme.labelSmall,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Column(
  //                   children: [
  //                     Text(
  //                       '4 gms',
  //                       style: Theme.of(context).textTheme.labelSmall,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Column(
  //                   children: [
  //                     Text(
  //                       '0.3 gms',
  //                       style: Theme.of(context).textTheme.labelSmall,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Column(
  //                   children: [
  //                     Text(
  //                       '3.5 gms',
  //                       style: Theme.of(context).textTheme.labelSmall,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(6),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 child: Column(
  //                   children: [
  //                     Text(
  //                       'Protiens',
  //                       style: Theme.of(context).textTheme.bodySmall,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Column(
  //                   children: [
  //                     Text(
  //                       'Carbs',
  //                       style: Theme.of(context).textTheme.bodySmall,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Column(
  //                   children: [
  //                     Text(
  //                       'Fats',
  //                       style: Theme.of(context).textTheme.bodySmall,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Column(
  //                   children: [
  //                     Text(
  //                       'Fibers',
  //                       style: Theme.of(context).textTheme.bodySmall,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         const Divider(),
  //         Row(
  //           children: [
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: const [
  //                 Text('Food Name'),
  //                 SizedBox(height: 10),
  //                 Text('Quantity : 100 gms'),
  //               ],
  //             ),
  //             const Spacer(),
  //             IconButton(
  //               onPressed: () {
  //                 showBtmSheet(context);
  //               },
  //               icon: const Icon(
  //                 Icons.edit_note_rounded,
  //                 size: 26,
  //               ),
  //               splashRadius: 18,
  //             ),
  //             IconButton(
  //               onPressed: () {},
  //               icon: const Icon(
  //                 Icons.close_rounded,
  //                 size: 26,
  //               ),
  //               splashRadius: 18,
  //             ),
  //           ],
  //         ),
  //         const Divider(),
  //       ],
  //     ),
  //   );
  // }

  void showPopUp(context) {
    List options = [
      {
        'title': 'Add Meal',
        'bool': true,
      },
      {
        'title': 'Change Goal',
        'bool': false,
      },
    ];
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Select an option',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Card(
                          elevation: 0,
                          color: Theme.of(context).canvasColor,
                          // color: const Color.fromARGB(255, 34, 34, 34),
                          child: InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              options[index]['bool']
                                  ? addMealPopUp(context)
                                  : Navigator.pop(context);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    options[index]['title'],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void addMealPopUp(BuildContext context) {
    String name = "", time;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add meal info',
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
                DropdownButtonFormField<String>(
                  style: Theme.of(context).textTheme.bodyMedium,
                  hint: const Text("Select a meal"),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.25,
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey,
                  ),
                  items: <String>[
                    'Breakfast',
                    'Morning Snack',
                    'Lunch',
                    'Afternoon Snack',
                    'Dinner'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      String result = MealSwitchCase().upperToLower(value);
                      name = result;
                    }
                  },
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   child: TextFormField(
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(8),
                //         borderSide: const BorderSide(
                //           color: Color(0xFFC3CAD9),
                //         ),
                //       ),
                //       constraints: const BoxConstraints(
                //         maxHeight: 50,
                //       ),
                //       hintText: 'Meal name',
                //       hintStyle: const TextStyle(
                //         color: Color(0xFF959EAD),
                //         fontSize: 16,
                //         fontWeight: FontWeight.w500,
                //         fontFamily: 'OpenSans',
                //       ),
                //     ),
                //     onChanged: (value) {
                //       name = value;
                //     },
                //     validator: (value) {
                //       return null;
                //     },
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: StatefulBuilder(
                //     builder: (context, newState) => Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text(
                //           _selectedTime == null
                //               ? TimeOfDay.now().format(context)
                //               : _selectedTime!.format(context),
                //           style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                //                 color: whiteColor,
                //               ),
                //         ),
                //         TextButton(
                //           onPressed: () {
                //             _timePicker(context, newState);
                //           },
                //           child: const Text('Edit'),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                ElevatedButton(
                  onPressed: () {
                    if (name.isEmpty) {
                      Fluttertoast.showToast(msg: "Please enter a meal name");
                      Navigator.of(context).pop();
                      return;
                    }
                    dietLog.add(
                      DietLog(
                        mealName: name,
                        dishes: [],
                      ),
                    );
                    widgetState!(() {});
                    Navigator.of(context).pop();
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

  void _timePicker(context, StateSetter thisState) {
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

  void showBtmSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Food name',
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
              Text(
                'Category : vegetables',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Food sub-type :  raw',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.restaurant_menu_outlined,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '32 kCal',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const Divider(),
              Text(
                'Enter food consumption quantity',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFC3CAD9),
                          ),
                        ),
                        constraints: const BoxConstraints(
                          maxHeight: 38,
                          maxWidth: 100,
                        ),
                        hintText: 'Quantity',
                        hintStyle: const TextStyle(
                          color: Color(0xFF959EAD),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      onSaved: (value) {},
                      validator: (value) {
                        return null;
                      },
                    ),
                    Text(
                      'grams',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Divider(),
              Text(
                'Nutritional Information',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 10),
              nutrientInfo(Colors.red, 'Protiens', 1.8),
              nutrientInfo(Colors.green, 'Carbs', 7.0),
              nutrientInfo(Colors.blue, 'Fats', 2.4),
              nutrientInfo(Colors.yellow, 'Fibers', 0.5),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget nutrientInfo(
    Color nutrientColor,
    String nutrientName,
    double nutrientQty,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: nutrientColor,
            radius: 6,
          ),
          const SizedBox(width: 10),
          Text(nutrientName),
          const Spacer(),
          Text('$nutrientQty gms'),
        ],
      ),
    );
  }

  void calculateCalories() {
    totalCalories = 0;
    protiens = 0;
    carbs = 0;
    fats = 0;
    fibers = 0;
    try {
      for (var ele1 in dietLog) {
        if (ele1.dishes == null) {
          // log("1");
          continue;
        }
        for (var ele in ele1.dishes!) {
          // log("1");
          var tempQuantity = ele.quantity;
          var baseCalories = ele.dishId!.perUnit!.calories;
          totalCalories = totalCalories + tempQuantity! * baseCalories!;

          protiens = double.parse((protiens +
                  (ele.dishId!.nutrition![0].proteins!.quantity! *
                      tempQuantity))
              .toStringAsPrecision(4));
          carbs = double.parse((carbs +
                  (ele.dishId!.nutrition![0].carbs!.quantity! * tempQuantity))
              .toStringAsPrecision(3));
          fats = double.parse((fats +
                  (ele.dishId!.nutrition![0].fats!.quantity! * tempQuantity))
              .toStringAsPrecision(3));
          fibers = double.parse((fibers +
                  (ele.dishId!.nutrition![0].fiber!.quantity! * tempQuantity))
              .toStringAsPrecision(3));
        }
      }

      String today = DateFormat("yyyy/MM/dd").format(DateTime.now());
      if (today == currentDate) {
        updateCaloriesTracker(totalCalories);
        if (mounted) {
          widgetState!(() {});
        }
      }

      // if (widgetState != null) {

      // }
    } catch (e) {
      log("Unable to calculate calories in view diet plans $e");
    }
  }

  void updateCaloriesTracker(double value) {
    Future.delayed(
        Duration.zero,
        () => Provider.of<CalorieTrackerProvider>(context, listen: false)
            .updateCaloriesTrackerConsumption(value.toString()));
  }
}
