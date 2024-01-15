import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/exercise/exercise.dart';
import 'package:healthonify_mobile/models/workout/set_type_models.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/exercises/expert_exercise_details.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/hep_edit_widgets/edit_add_sets_bottomsheet.dart';

class EditHepPlan extends StatefulWidget {
  final ExerciseWorkoutModel exData;
  final bool isEdit;
  final Function updateEditedPlan;
  final int index;
  final bool hasWorkoutStarted;
  final Function({required ExerciseWorkoutModel data}) addEx;
  final Function({required ExerciseWorkoutModel data}) removeEx;

  const EditHepPlan({
    Key? key,
    required this.exData,
    required this.isEdit,
    required this.updateEditedPlan,
    required this.index,
    this.hasWorkoutStarted = false,
    required this.addEx,
    required this.removeEx,
  }) : super(key: key);

  @override
  State<EditHepPlan> createState() => _EditHepPlanState();
}

class _EditHepPlanState extends State<EditHepPlan> {
  @override
  void initState() {
    super.initState();
  }

  bool checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    Exercise exercise = Exercise(
      id: widget.exData.exerciseId!["_id"],
      // bodyPartGroupId: [
      //   {
      //     "name": widget.exData.bodyPartId!["name"],
      //     "id": widget.exData.bodyPartId!["_id"],
      //   }
      // ],
      bodyPartId: [
        {
          "name": widget.exData.bodyPartGroupId!["name"],
          "id": widget.exData.bodyPartGroupId!["_id"],
        }
      ],
      mediaLink: widget.exData.exerciseId!["mediaLink"],
      name: widget.exData.exerciseId!["name"],
      weightUnit: "",
    );

    return !widget.hasWorkoutStarted
        ? buildWidget(exercise)
        : CheckboxListTile(
            value: checkboxValue,
            onChanged: (value) {
              setState(() {
                checkboxValue = !checkboxValue;
              });
              if (checkboxValue) {
                widget.addEx(data: widget.exData);
              } else {
                widget.removeEx(data: widget.exData);
              }
            },
            title: buildWidget(exercise));
  }

  Widget buildWidget(Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            // Fluttertoast.showToast(msg: "Ex details screen");
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => ExerciseDetailsScreen(
                          exerciseData: exercise,
                          sets: widget.exData.sets!,
                          // sets: widget.exData.sets!.length.toString(),
                          // reps: widget.exData.sets![0].reps!,
                        )))
                .then((value) {});
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise.name ?? "",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // const Text("Active ROM"),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Row(
                          //   children: const [
                          //     Icon(Icons.line_axis),
                          //     SizedBox(
                          //       width: 5,
                          //     ),
                          //     Text("Long Sitting"),
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 110,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: exercise.mediaLink == null ||
                                      exercise.mediaLink!.isEmpty
                                  ? const NetworkImage(
                                      "https://images.theconversation.com/files/460514/original/file-20220429-20-h0umhf.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=1200.0&fit=crop")
                                  : CachedNetworkImageProvider(
                                      exercise.mediaLink!) as ImageProvider,
                              fit: BoxFit.cover),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text("Sequence : ${widget.exData.round!}"),
                    const SizedBox(
                      width: 5,
                    ),
                    Text("Sets : ${widget.exData.sets!.length}"),
                  ],
                ),
              ),
              // Container(
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     borderRadius: const BorderRadius.only(
              //       bottomLeft: Radius.circular(10),
              //       bottomRight: Radius.circular(10),
              //     ),
              //     color: Theme.of(context).canvasColor,
              //   ),
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceAround,
              //       // spaceBetween
              //       children: [
              //         Row(
              //           children: const [
              //             Icon(Icons.videocam),
              //             SizedBox(
              //               width: 10,
              //             ),
              //             Text("Ankle"),
              //           ],
              //         ),
              //         // Row(
              //         //   children: [
              //         //     const Icon(Icons.home_repair_service),
              //         //     const SizedBox(
              //         //       width: 10,
              //         //     ),
              //         //     Text(exercise.bodyPartGroupId![0]["name"]),
              //         //   ],
              //         // ),
              //         if (widget.isEdit)
              //           InkWell(
              //             onTap: () {
              //               showAddExerciseDialog(context, widget.exData);
              //             },
              //             child: CircleAvatar(
              //               backgroundColor:
              //                   Theme.of(context).colorScheme.secondary,
              //               radius: 15,
              //               child: const Icon(
              //                 Icons.edit,
              //                 size: 20,
              //                 color: whiteColor,
              //               ),
              //             ),
              //           )
              //         // InkWell(
              //         //   onTap: () {
              //         //     showDialog(
              //         //         context: context,
              //         //         builder: (context) => const AddExcDialog());
              //         //   },
              //         //   child: CircleAvatar(
              //         //     backgroundColor:
              //         //         Theme.of(context).colorScheme.secondary,
              //         //     radius: 15,
              //         //     child: const Icon(
              //         //       Icons.delete,
              //         //       size: 20,
              //         //       color: whiteColor,
              //         //     ),
              //         //   ),
              //         // )
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  void showAddExerciseDialog(
    context,
    ExerciseWorkoutModel exercise,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return EditAddSetsBottomsheet(
          exModel: exercise,
          saveData: (Map<String, dynamic> data) {
            log("edit model");
            ExerciseWorkoutModel model = ExerciseWorkoutModel(
              round: data["sequence"],
              group: data["exGroup"],
              bodyPartGroupId: exercise.bodyPartGroupId,
              bodyPartId: exercise.bodyPartId,
              setType: getSetType(data["sets"]),
              exerciseId: {
                "name": exercise.exerciseId!["name"],
                "mediaLink": exercise.exerciseId!["mediaLink"],
                "_id": exercise.exerciseId!["_id"],
              },
              note: data["setsNote"],
              sets: setSets(
                data["sets"],
              ),
            );
            // log(model.sets![0].weight!);
            // setState(() {
            //   widget.exData = model;
            // });
            widget.updateEditedPlan(model, widget.index);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  String getSetType(SetTypeData data) {
    if (data.data.runtimeType == List<WeightReps>) {
      return "Weight & Reps";
    } else if (data.data.runtimeType == List<Reps>) {
      return "Reps only";
    } else if (data.data.runtimeType == List<Time>) {
      return "Time only";
    } else if (data.data.runtimeType == List<TimeDistance>) {
      return "Time & Distance";
    } else if (data.data.runtimeType == List<ExNameReps>) {
      return "Exercise Name & Reps";
    } else if (data.data.runtimeType == List<ExNameTime>) {
      return "Exercise Name & Time";
    } else if (data.data.runtimeType == List<ExNameRepsTime>) {
      return "Exercise Name, Reps & Time";
    } else if (data.data.runtimeType == List<DistanceTimeSets>) {
      return "Distance, Time, Speed & Sets";
    } else if (data.data.runtimeType == List<DistanceSpeed>) {
      return "Distance & Speed";
    } else if (data.data.runtimeType == List<DistanceModel>) {
      return "Distance";
    } else {
      return "Time & Speed";
    }
  }

  List<Set> setSets(SetTypeData data) {
    if (data.data.runtimeType == List<WeightReps>) {
      List<WeightReps> tempData = data.data;
      List<Set> setsData = List.generate(
        tempData.length,
        (index) => Set(
          weight: tempData[index].weight,
          weightUnit: tempData[index].unit,
          reps: tempData[index].reps,
        ),
      );

      return setsData;
    }
    if (data.data.runtimeType == List<Reps>) {
      List<Reps> tempData = data.data;
      List<Set> setsData = List.generate(
        tempData.length,
        (index) => Set(
          reps: tempData[index].reps,
        ),
      );

      return setsData;
    }
    if (data.data.runtimeType == List<Time>) {
      List<Time> tempData = data.data;
      List<Set> setsData = List.generate(
        tempData.length,
        (index) => Set(
          time: tempData[index].time,
          timeUnit: tempData[index].unit,
        ),
      );

      return setsData;
    }
    if (data.data.runtimeType == List<TimeDistance>) {
      List<TimeDistance> tempData = data.data;
      List<Set> setsData = List.generate(
        tempData.length,
        (index) => Set(
          time: tempData[index].time,
          timeUnit: tempData[index].timeUnit,
          distance: tempData[index].distance,
          distanceUnit: tempData[index].distanceUnit,
        ),
      );

      return setsData;
    }
    if (data.data.runtimeType == List<ExNameReps>) {
      List<ExNameReps> tempData = data.data;
      List<Set> setsData = List.generate(
        tempData.length,
        (index) => Set(
          name: tempData[index].name,
          reps: tempData[index].reps,
        ),
      );
      return setsData;
    }
    if (data.data.runtimeType == List<ExNameTime>) {
      List<ExNameTime> tempData = data.data;
      List<Set> setsData = List.generate(
        tempData.length,
        (index) => Set(
          name: tempData[index].name,
          time: tempData[index].time,
          timeUnit: tempData[index].timeUnit,
        ),
      );
      return setsData;
    }
    if (data.data.runtimeType == List<ExNameRepsTime>) {
      List<ExNameRepsTime> tempData = data.data;
      List<Set> setsData = List.generate(
        tempData.length,
        (index) => Set(
          name: tempData[index].name,
          time: tempData[index].time,
          timeUnit: tempData[index].timeUnit,
          reps: tempData[index].reps,
        ),
      );
      return setsData;
    }
    if (data.data.runtimeType == List<DistanceTimeSets>) {
      List<DistanceTimeSets> tempData = data.data;
      List<Set> setsData = List.generate(
        tempData.length,
        (index) => Set(
          distance: tempData[index].distance,
          distanceUnit: tempData[index].distanceUnit,
          time: tempData[index].time,
          timeUnit: tempData[index].timeUnit,
          speed: tempData[index].speed,
          set: tempData[index].sets,
        ),
      );
      return setsData;
    }

    if (data.data.runtimeType == List<DistanceSpeed>) {
      List<DistanceSpeed> tempData = data.data;
      List<Set> setsData = List.generate(
        tempData.length,
        (index) => Set(
          distance: tempData[index].distance,
          distanceUnit: tempData[index].distanceUnit,
          speed: tempData[index].speed,
        ),
      );
      return setsData;
    }
    if (data.data.runtimeType == List<DistanceModel>) {
      List<DistanceModel> tempData = data.data;
      List<Set> setsData = List.generate(
        tempData.length,
        (index) => Set(
          distance: tempData[index].distance,
          distanceUnit: tempData[index].distanceUnit,
        ),
      );
      return setsData;
    }
    if (data.data.runtimeType == List<TimeSpeedModel>) {
      List<TimeSpeedModel> tempData = data.data;
      List<Set> setsData = List.generate(
        tempData.length,
        (index) => Set(
          time: tempData[index].time,
          timeUnit: tempData[index].timeUnit,
          speed: tempData[index].speed,
        ),
      );
      return setsData;
    } else {
      return [Set()];
    }
  }
}
