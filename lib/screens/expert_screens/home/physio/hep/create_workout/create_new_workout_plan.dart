import 'dart:developer';

import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/exercise/workout_types.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/workout/add_workout_temp_model.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/hep/create_workout/create_workout_plan_details.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class CreateNewWorkoutPlan extends StatefulWidget {
  const CreateNewWorkoutPlan({Key? key}) : super(key: key);

  @override
  State<CreateNewWorkoutPlan> createState() => _CreateNewWorkoutPlanState();
}

class _CreateNewWorkoutPlanState extends State<CreateNewWorkoutPlan> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isWorkoutDays = true;

  AddWorkoutModel workoutModel = AddWorkoutModel();
  void getName(String value) => workoutModel.name = value;
  void getDuration(String value) {
    workoutModel.duration = value;
    setState(() {
      duration = value;
    });
  }

  void getNoOfDays(String value) => workoutModel.noOfDays = value;
  void getNote(String value) => workoutModel.note = value;
  void getGoal(String value) => {
        workoutModel.goal = value,
        setState(() {
          goal = value;
        })
      };
  void getLevel(String value) {
    workoutModel.level = value;
    setState(() {
      level = value;
    });
  }

  String goal = "Select", level = "Select", duration = "Select";

  void onSubmit() {
    if (!_key.currentState!.validate()) {
      return;
    }
    _key.currentState!.save();

    if (workoutModel.goal == null || workoutModel.goal!.isEmpty) {
      Fluttertoast.showToast(msg: "Please select your goal");
      return;
    } else if (workoutModel.level == null || workoutModel.level!.isEmpty) {
      Fluttertoast.showToast(msg: "Please select a level");
      return;
    } else if (workoutModel.duration == null ||
        workoutModel.duration!.isEmpty) {
      Fluttertoast.showToast(msg: "Please select a duration");
      return;
    }

    log(workoutModel.duration.toString());
    log(workoutModel.goal.toString());

    log(workoutModel.level.toString());

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            CreateWorkoutPlanDetails(workoutModel: workoutModel),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    workoutModel.note = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Add Workout Plan'),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Text('Name'),
                ),
                textFields(
                  context,
                  'Workout plan name, eg. Beginner plan.',
                  false,
                  getName,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Text('Goal'),
                ),
                dropdownDialog(goalDropdownOptions, goal, getGoal),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Text('Level'),
                ),
                dropdownDialog(levelDropdownOptions, level, getLevel),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Text('Duration'),
                ),
                dropdownDialog(durationDropdownOptions, duration, getDuration),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Text('No of days'),
                ),
                textFields(
                    context, 'Total Workout Days', isWorkoutDays, getNoOfDays),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Text('Note'),
                ),
                textFields(context, 'Add note (Optional)', false, getNote),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: orangeGradient,
        ),
        child: TextButton(
          onPressed: () {
            onSubmit();
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return const MyPlanDetails(planName: 'workout plan name');
            // }));
          },
          child: Text(
            'SUBMIT',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: whiteColor),
          ),
        ),
      ),
    );
  }

  String selected = "Select";

  Widget dropdownDialog(
    List options,
    String title,
    Function getFunc,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: grey,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          onTap: () {
            showPopUp(options, title, getFunc);
          },
          tileColor: Theme.of(context).canvasColor,
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.grey),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey,
            size: 26,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
  }

  void showPopUp(List options, String title, Function getFunc) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Theme.of(context).canvasColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        getFunc(options[index]["value"]);
                      },
                      title: Text(
                        options[index]["name"],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget textFields(
      context, String hintText, bool isWorkoutField, Function getValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: TextFormField(
        keyboardType: isWorkoutField ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          fillColor: Theme.of(context).canvasColor,
          filled: true,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: const Color(0xFF717579),
              ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        cursorColor: whiteColor,
        validator: (String? value) {
          if (hintText == "Add note (Optional)") {
            return null;
          } else {
            if (value!.isEmpty) {
              return "Please enter a value";
            }
          }
          return null;
        },
        onSaved: (newValue) => getValue(newValue),
      ),
    );
  }
}
