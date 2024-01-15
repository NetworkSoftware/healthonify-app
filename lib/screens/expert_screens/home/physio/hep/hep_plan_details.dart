import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/exercises/expert_exercises_screen.dart';
import 'package:healthonify_mobile/widgets/buttons/customappbar_action_btns.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/edit_hep_plan.dart';

class HepPlanDetails extends StatefulWidget {
  final Schedule schedule;
  final String title;
  final bool isEdit;
  const HepPlanDetails(
      {Key? key,
      required this.title,
      required this.schedule,
      this.isEdit = false})
      : super(key: key);

  @override
  State<HepPlanDetails> createState() => _HepPlanDetailsState();
}

class _HepPlanDetailsState extends State<HepPlanDetails> {
  List<ExerciseWorkoutModel> exmodel = [];
  @override
  void initState() {
    super.initState();
    if (widget.schedule.exercises != null) {
      exmodel.addAll(widget.schedule.exercises!);
    }
  }

  void updatePlan(ExerciseWorkoutModel ex, int index) {
    log(" index $index");
    setState(() {
      exmodel[index] = ex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: widget.title,
        widgetRight: !widget.isEdit
            ? const SizedBox()
            : CustomAppBarTextBtn(
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
              ),
      ),
      body: exmodel.isEmpty
          ? const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Center(child: Text("No exercises added")),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: exmodel.length,
              itemBuilder: (_, index) => EditHepPlan(
                    exData: exmodel[index],
                    isEdit: widget.isEdit,
                    updateEditedPlan: updatePlan,
                    index: index,
                    addEx: ({required ExerciseWorkoutModel data}) {},
                    removeEx: ({required ExerciseWorkoutModel data}) {},
                  )),
      bottomNavigationBar: !widget.isEdit
          ? const SizedBox()
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              height: 60,
              alignment: Alignment.centerLeft,
              color: Theme.of(context).colorScheme.secondary,
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => const ExpertExercisesScreen(
                        isSelectEx: true,
                      ),
                    ),
                  )
                      .then((value) {
                    if (value != null) {
                      ExerciseWorkoutModel model = value;
                      // log("Hey ${model.sets}");
                      // for (var ele in model.sets!) {
                      //   log(ele.reps!);
                      // }
                      log("Hey");
                      setState(() {
                        exmodel.add(model);
                      });
                    }
                  });
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: whiteColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Add new exercise',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(color: whiteColor),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
