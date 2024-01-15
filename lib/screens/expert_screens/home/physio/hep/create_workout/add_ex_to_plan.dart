import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/workout/add_workout_temp_model.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/exercises/expert_exercises_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/customappbar_action_btns.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/create_hep_ex_card.dart';

class AddExToPlan extends StatefulWidget {
  final List<ExerciseWorkoutModel> exercises;
  final AddWorkoutModel workoutModel;
  final int dayNumber;
  const AddExToPlan({
    Key? key,
    required this.exercises,
    required this.workoutModel,
    required this.dayNumber,
  }) : super(key: key);

  @override
  State<AddExToPlan> createState() => _AddExToPlanState();
}

class _AddExToPlanState extends State<AddExToPlan> {
  List<ExerciseWorkoutModel> exmodel = [];
  @override
  void initState() {
    super.initState();
    exmodel.addAll(widget.exercises);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(
          appBarTitle: "Day ${widget.dayNumber}",
          widgetRight: CustomAppBarTextBtn(
            title: "Add to plan",
            onClick: () async {
              // await PostWorkoutFunc().postWorkoutData(context,
              //     ex: exmodel, workoutModel: widget.workoutModel);
              if (exmodel.isNotEmpty) {
                Navigator.of(context).pop(exmodel);
              } else {
                Fluttertoast.showToast(
                    msg: "Please choose an exercise to add to plan");
              }
            },
          )),
      body: exmodel.isEmpty
          ? const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Center(child: Text("No exercises added")),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: exmodel.length,
              itemBuilder: (_, index) => CreateHepExCard(
                exData: exmodel[index],
                deleteExercise: () {
                  setState(() {
                    exmodel.removeAt(index);
                  });
                },
              ),
            ),
      bottomNavigationBar: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: orangeGradient,
        ),
        child: TextButton(
          onPressed: () {
            // onSubmit();
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const ExpertExercisesScreen(
                isSelectEx: true,
              );
            })).then((value) {
              log(value.toString());
              if (value != null) {
                ExerciseWorkoutModel model = value;
                // log("Hey ${model.sets}");
                // for (var ele in model.sets!) {
                //   log(ele.reps!);
                // }
                setState(() {
                  exmodel.add(model);
                });
              }
            });
          },
          child: Text(
            'Add Exercise',
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(color: whiteColor),
          ),
        ),
      ),
    );
  }
}
