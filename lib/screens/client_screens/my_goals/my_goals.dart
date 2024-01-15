// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/client/goals/goals_constants.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/goals_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/weight_goal/weight_goal_provider.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum RadioTitles1 { radio1, radio2, radio3, radio4, radio5, radio6, radio7 }

enum RadioTitles2 { radio1, radio2, radio3, radio4 }

class MyGoalsScreen extends StatefulWidget {
  const MyGoalsScreen({Key? key}) : super(key: key);

  @override
  State<MyGoalsScreen> createState() => _MyGoalsScreenState();
}

class _MyGoalsScreenState extends State<MyGoalsScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController currentWeightController = TextEditingController();
  TextEditingController goalWeightController = TextEditingController();
  TextEditingController caloryController = TextEditingController();

  late String userId;

  Map<String, dynamic> goalMap = {};

  Future postWeightGoal() async {
    try {
      await Provider.of<WeightGoalProvider>(context, listen: false)
          .postWeightGoals(goalMap).then((value) {
        getWeightGoal();
      });
      Fluttertoast.showToast(msg: 'Weight Goals uploaded successfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to upload weight goal');
    }
  }

  void onSubmit() async {
    var userId = Provider.of<UserData>(context, listen: false).userData.id!;
    goalMap['userId'] = userId;
    LoadingDialog().onLoadingDialog("Please wait...", context);
    await postWeightGoal();
    Navigator.of(context, rootNavigator: true).pop();
  }

  void clearGoalMap() {
    setState(() {
      goalMap = {};
    });
  }

  String? startWght;
  String? sWeight;
  String? sDate;
  String? cWeight;
  String? weightGoal;
  String? weeklygoal;
  String? actLevel;
  String? burnCalory;

  bool isLoading = true;

  List myGoalsData = [];

  List<WeightGoalModel> goalData = [];
  Object? defaultRadio2 = RadioTitles2.radio1;

  Future<void> getWeightGoal() async {
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      goalData = await Provider.of<WeightGoalProvider>(context, listen: false)
          .getWeightGoals(userId);

      if (goalData.isNotEmpty) {
        sWeight = goalData[0].startingWeight;
        var temp = goalData[0].date;
        var tempDateTime = DateFormat('yyyy-MM-dd').parse(temp!);
        sDate = DateFormat('dd/MM/yyyy').format(tempDateTime);

        print("Current weight : ${goalData[0].currentWeight}");
        if (sWeight != null && sDate != null) {
          startWght = '$sWeight kgs on $sDate';
        } else {
          startWght = '-';
        }

        myGoalsData = [
          {
            'title': 'Starting Weight',
            'data': startWght,
            'func': () {
              startingWeightFunc();
            },
          },
          {
            'title': 'Current Weight (kgs)',
            'data': goalData[0].currentWeight ?? '-',
            'func': () {
              currentWeightFunc();
            },
          },
          {
            'title': 'Target Goal Weight (kgs)',
            'data': goalData[0].goalWeight ?? '-',
            'func': () {
              goalWeightFunc();
            },
          },
          {
            'title': 'Weekly Goal',
            'data': goalData[0].weeklyGoal ?? 'Choose weekly goal',
            'func': () {
              weeklyGoalFunc();
            },
          },
          {
            'title': 'Activity Level',
            'data': goalData[0].activityLevel ?? 'Select activity level',
            'func': () {
              activityLevelFunc();
            },
          },
          {
            'title': 'How many Calories you want to burn in a day',
            'data': goalData[0].goalCalories ?? '-',
            'func': () {
              caloriesBurntInADayFunc();
            },
          },
        ];
      }
      else {
        myGoalsData = [
          {
            'title': 'Starting Weight',
            'data': "-",
            'func': () {
              startingWeightFunc();
            },
          },
          {
            'title': 'Current Weight (kgs)',
            'data': '-',
            'func': () {
              currentWeightFunc();
            },
          },
          {
            'title': 'Target Goal Weight (kgs)',
            'data': '-',
            'func': () {
              goalWeightFunc();
            },
          },
          {
            'title': 'Weekly Goal',
            'data': 'Choose weekly goal',
            'func': () {
              weeklyGoalFunc();
            },
          },
          {
            'title': 'Activity Level',
            'data': 'Select activity level',
            'func': () {
              activityLevelFunc();
            },
          },
          {
            'title': 'How many Calories you want to burn in a day',
            'data': '-',
            'func': () {
              caloriesBurntInADayFunc();
            },
          },
        ];
      }

      setState((){});
      log('fetched weight goals');
    } on HttpException catch (e) {
      log('HTTP Exception: $e');
    } catch (e) {
      log("Error getting weight goals: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getWeightGoal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: 'Goals',
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          icon: Icon(
            Icons.chevron_left_rounded,
            color: Theme.of(context).colorScheme.onBackground,
            size: 40,
          ),
          splashRadius: 20,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    color: Theme.of(context).canvasColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: myGoalsData[index]['func'],
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      myGoalsData[index]['title'],
                                      maxLines: 2,
                                      style:
                                          Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ),
                                  Text(
                                    myGoalsData[index]['data'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Colors.blue[400],
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.grey[700],
                          );
                        },
                        itemCount: myGoalsData.length,
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(15),
                  //   child: Text(
                  //     'Fitness Goals',
                  //     style: Theme.of(context).textTheme.labelLarge,
                  //   ),
                  // ),
                  // const FitnessGoalWidget(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  DateTime? _selectedDate;
  String? formattedDate;
  String? mapDate;

  void datePicker(context, TextEditingController controller) {
    showDatePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: datePickerDarkTheme,
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        log(value.toString());
        _selectedDate = value;
        var tempDate = DateFormat.yMd().format(_selectedDate!);
        DateTime temp = DateFormat('MM/dd/yyyy').parse(tempDate);
        mapDate = DateFormat('yyyy-MM-dd').format(temp);
        formattedDate = DateFormat('dd/MM/yyyy').format(temp);
        log(formattedDate!);
        controller.text = formattedDate!;
      });
    });
  }

  void startingWeightFunc() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: weightController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      //fillColor: Colors.grey[800]!.withOpacity(0.5),
                      filled: true,
                      hintText: 'Starting weight in kgs',
                      hintStyle:
                          Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: const Color(0xFF717579),
                              ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(6),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    cursorColor: whiteColor,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      datePicker(context, dateController);
                    },
                    child: IgnorePointer(
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          filled: true,
                          //fillColor: Colors.grey[800]!.withOpacity(0.5),
                          labelText: 'Choose date',
                          alignLabelWithHint: true,
                          labelStyle:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.grey[600],
                                  ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              datePicker(context, dateController);
                            },
                            icon: const Icon(
                              Icons.event_rounded,
                              color: orange,
                            ),
                            splashRadius: 20,
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: GradientButton(
                    title: 'Confirm',
                    func: () {
                      Navigator.pop(context);
                      setState(() {
                        sWeight = weightController.text;
                        sDate = formattedDate!;
                        goalMap['date'] = mapDate;
                        goalMap['startingWeight'] = sWeight;
                        onSubmit();
                       // getWeightGoal();
                      });
                      log(goalMap.toString());
                      
                    },
                    gradient: orangeGradient,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void caloriesBurntInADayFunc() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: caloryController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      //fillColor: Colors.grey[800]!.withOpacity(0.5),
                      filled: true,
                      hintText: 'Burn Calories',
                      hintStyle:
                      Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: const Color(0xFF717579),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(6),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    cursorColor: whiteColor,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: GradientButton(
                    title: 'Confirm',
                    func: () {
                      clearGoalMap();
                      setState(() {
                        burnCalory = caloryController.text;
                        goalMap['goalCalories'] = burnCalory ?? "";
                        onSubmit();
                      });
                      log(goalMap.toString());
                      Navigator.pop(context);
                      //getWeightGoal();
                    },
                    gradient: orangeGradient,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void currentWeightFunc() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: currentWeightController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      //fillColor: Colors.grey[800]!.withOpacity(0.5),
                      filled: true,
                      hintText: 'Current weight in kgs',
                      hintStyle:
                          Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: const Color(0xFF717579),
                              ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(6),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    cursorColor: whiteColor,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: GradientButton(
                    title: 'Confirm',
                    func: () {
                      clearGoalMap();
                      setState(() {
                        cWeight = currentWeightController.text;
                        goalMap['currentWeight'] = cWeight ?? "";
                        onSubmit();
                      });
                      log(goalMap.toString());
                      Navigator.pop(context);
                    },
                    gradient: orangeGradient,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void goalWeightFunc() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    controller: goalWeightController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      //fillColor: Colors.grey[800]!.withOpacity(0.5),
                      filled: true,
                      hintText: 'Target goal weight in kgs',
                      hintStyle:
                          Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: const Color(0xFF717579),
                              ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(6),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    cursorColor: whiteColor,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: GradientButton(
                    title: 'Confirm',
                    func: () {
                      clearGoalMap();
                      setState(() {
                        weightGoal = goalWeightController.text;
                        goalMap['goalWeight'] = weightGoal;
                      });
                      onSubmit();
                      log(goalMap.toString());
                      Navigator.pop(context);
                     // getWeightGoal();
                    },
                    gradient: orangeGradient,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void weeklyGoalFunc() {
    Object? defaultRadio1 = RadioTitles1.radio1;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: StatefulBuilder(
              builder: (context, newState) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: weeklyGoalOptions.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        value: RadioTitles1.values[index],
                        groupValue: defaultRadio1,
                        controlAffinity: ListTileControlAffinity.trailing,
                        onChanged: (value) {
                          newState(() {
                            defaultRadio1 = value;
                          });
                        },
                        title: Text(
                          weeklyGoalOptions[index]['title'],
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: GradientButton(
                      title: 'Set',
                      func: () {
                        clearGoalMap();
                        setState(() {
                          getWeeklyGoalValue(defaultRadio1);
                          goalMap['weeklyGoal'] = weeklygoal;
                        });
                        onSubmit();
                        log(goalMap.toString());
                        Navigator.pop(context);
                        //getWeightGoal();
                      },
                      gradient: orangeGradient,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void getWeeklyGoalValue(value) {
    if (value == RadioTitles1.radio1) {
      weeklygoal = weeklyGoalOptions[0]['title'];
    } else if (value == RadioTitles1.radio2) {
      weeklygoal = weeklyGoalOptions[1]['title'];
    } else if (value == RadioTitles1.radio3) {
      weeklygoal = weeklyGoalOptions[2]['title'];
    } else if (value == RadioTitles1.radio4) {
      weeklygoal = weeklyGoalOptions[3]['title'];
    } else if (value == RadioTitles1.radio5) {
      weeklygoal = weeklyGoalOptions[4]['title'];
    } else if (value == RadioTitles1.radio6) {
      weeklygoal = weeklyGoalOptions[5]['title'];
    } else if (value == RadioTitles1.radio7) {
      weeklygoal = weeklyGoalOptions[6]['title'];
    }
  }

  void activityLevelFunc() {

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: StatefulBuilder(
              builder: (context, thisState) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: activityLevelOptions.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          RadioListTile(
                            value: RadioTitles2.values[index],
                            groupValue: defaultRadio2,
                            controlAffinity: ListTileControlAffinity.trailing,
                            onChanged: (value) {
                              thisState(() {
                                defaultRadio2 = value;
                              });
                            },
                            title: Text(
                              activityLevelOptions[index]['title'],
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              activityLevelOptions[index]['description'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.grey),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: GradientButton(
                      title: 'Set',
                      func: () {
                        clearGoalMap();
                        setState(() {
                          getActivityLevel(defaultRadio2);
                          goalMap['activityLevel'] = actLevel;
                        });
                        onSubmit();
                        log(goalMap.toString());
                        Navigator.pop(context);
                        //getWeightGoal();
                      },
                      gradient: orangeGradient,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void getActivityLevel(value) {
    if (value == RadioTitles2.radio1) {
      actLevel = activityLevelOptions[0]['title'];
    } else if (value == RadioTitles2.radio2) {
      actLevel = activityLevelOptions[1]['title'];
    } else if (value == RadioTitles2.radio3) {
      actLevel = activityLevelOptions[2]['title'];
    } else if (value == RadioTitles2.radio4) {
      actLevel = activityLevelOptions[3]['title'];
    }
  }
}

class FitnessGoalWidget extends StatelessWidget {
  const FitnessGoalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: Column(
        children: [
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              fitnessGoalsFunc(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Workouts/week',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '0',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.blue[400],
                        ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[700],
          ),
          InkWell(
            onTap: () {
              fitnessGoalsFunc(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Minutes/workout',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '0',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.blue[400],
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void fitnessGoalsFunc(context) {
    String? selectedValue;
    List<String> workoutsPerWeek = List.generate(
      31,
      (int index) => index.toString(),
      growable: false,
    );
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatefulBuilder(
                  builder: (context, newState) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: DropdownButtonFormField(
                      isDense: true,
                      items: workoutsPerWeek
                          .map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        newState(() {
                          selectedValue = newValue!;
                        });
                      },
                      value: selectedValue,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.25,
                          ),
                        ),
                        constraints: const BoxConstraints(
                          maxHeight: 56,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      hint: Text(
                        'Workouts per week',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      //fillColor: Colors.grey[800]!.withOpacity(0.5),
                      filled: true,
                      hintText: 'Minutes per workout',
                      hintStyle:
                          Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: const Color(0xFF717579),
                              ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(6),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    cursorColor: whiteColor,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: GradientButton(
                    title: 'Confirm',
                    func: () {
                      Navigator.pop(context);
                    },
                    gradient: orangeGradient,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
