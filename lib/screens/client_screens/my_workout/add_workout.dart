import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/workout/add_workout_temp_model.dart';
import 'package:healthonify_mobile/screens/client_screens/my_workout/workout_day_plan_detail.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isWorkoutDays = true;
  List<Map<String, String>> dropDownOptions = [
    {"name": '1 day in a week', "value": "1"},
    {"name": '2 days in a week', "value": "2"},
    {"name": '3 days in a week', "value": "3"},
    {"name": '4 days in a week', "value": "4"},
    {"name": '5 days in a week', "value": "5"},
    {"name": '6 days in a week', "value": "6"},
    {"name": '7 days in a week', "value": "7"},
  ];
  AddWorkoutModel workoutModel = AddWorkoutModel();
  void getName(String value) => workoutModel.name = value;
  void getDuration(String value) => workoutModel.duration = value;
  void getNoOfDays(String value) => workoutModel.noOfDays = value;
  void getNote(String value) => workoutModel.note = value;

  void onSubmit() {
    if (!_key.currentState!.validate()) {
      return;
    }
    _key.currentState!.save();

    if (workoutModel.duration == null || workoutModel.duration!.isEmpty) {
      Fluttertoast.showToast(msg: "Please select a duration");
      return;
    }

    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (context) =>
    //         CreateWorkoutPlanDetails(workoutModel: workoutModel),
    //   ),
    // );

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WorkoutDayPlanDetails(
        workoutModel: workoutModel,
      );
    }));
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
                  child: Text('Duration'),
                ),
                dropdownDialog(context, dropDownOptions, ''),
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

  Widget dropdownDialog(context, List options, String title) {
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
            showPopUp(context, options, title);
          },
          tileColor: Theme.of(context).canvasColor,
          title: Text(
            selected,
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

  void showPopUp(context, List options, String title) {
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
                        getDuration(options[index]["value"]);
                        setState(() {
                          selected = options[index]["name"];
                        });
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
          if (value!.isEmpty) {
            return "Please enter a value";
          }
          return null;
        },
        onSaved: (newValue) => getValue(newValue),
      ),
    );
  }
}


  // List dropDownOptions1 = [
  //     'Fat Loss',
  //     'Muscle Gain',
  //     'Weight Gain',
  //     'General Fitness',
  //     'Maintain Weight',
  //     'Improve Flexibility',
  //     'Overall Health and Immunity',
  //     'Injury Rehabilitation',
  //     'Build Body Strength',
  //     'Weight Loss',
  //   ];
  //   List dropDownOptions2 = [
  //     'Beginner',
  //     'Intermediate',
  //     'Advanced',
  //     'General',
  //   ];
  //   List dropDownOptions3 = [
  //     '1 day in a week',
  //     '2 days in a week',
  //     '3 days in a week',
  //     '4 days in a week',
  //     '5 days in a week',
  //     '6 days in a week',
  //     '7 days in a week',
  //   ];
