import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/exercise/exercise.dart';
import 'package:healthonify_mobile/models/workout/set_type_models.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/exercises/expert_exercise_details.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/hep_edit_widgets/edit_add_sets_bottomsheet.dart';

import '../../../../main.dart';

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
  List<TrackExercise> trackExerciseList = [];

  @override
  Widget build(BuildContext context) {
    Exercise exercise = Exercise(
        id: widget.exData.exerciseId!["_id"],
        bodyPartGroupId: [
          {
            "name": widget.exData.bodyPartGroupId!["name"],
            "id": widget.exData.bodyPartGroupId!["_id"],
          }
        ],
        bodyPartId: [
          {
            "name": widget.exData.bodyPartId!["name"],
            "id": widget.exData.bodyPartId!["_id"],
          }
        ],
        mediaLink: widget.exData.exerciseId!["mediaLink"],
        name: widget.exData.exerciseId!["name"],
        weightUnit: 0);

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Card(
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                builder: (context) => ExerciseDetailsScreen(
                  exerciseData: exercise,
                  sets: widget.exData.sets!,
                  // sets: widget.exData.sets!.length.toString(),
                  // reps: widget.exData.sets![0].reps!,
                )))
                .then((value) {
              if (kSharedPreferences.getString("ExerciseData") != null) {
                String exerciseInfo =
                kSharedPreferences.getString("ExerciseData")!;
                final data = jsonDecode(exerciseInfo);

                print("Data : $data");

                TrackExercise trackExercise = TrackExercise(
                  id: data['id'],
                  name: data['name'],
                  exerciseStartTime: data['exerciseStartTime'],
                  exerciseEndTime: data['exerciseEndTime'],
                  totalTime: data['totalTime'],
                  status: data['status'],
                );

                if (trackExerciseList.isEmpty) {
                  if (data["status"] == "InProgress") {
                    trackExerciseList.add(trackExercise);
                    print("Length1 : ${trackExerciseList.length}");
                  } else {
                    trackExerciseList.add(trackExercise);
                    print("Length2 : ${trackExerciseList.length}");
                  }
                } else {
                  for (int i = 0; i < trackExerciseList.length; i++) {
                    if (trackExerciseList[i].id == trackExercise.id) {
                      print(
                          "Before Replace List Data : ${trackExerciseList[i]}");
                      final index = trackExerciseList
                          .indexWhere((ex) => ex.id == trackExercise.id);
                      trackExerciseList[index] = trackExercise;

                      print("Replace List Data : ${trackExerciseList[index]}");
                      print("Length3 : ${trackExerciseList.length}");
                    } else {
                      trackExerciseList.add(trackExercise);
                      print("Replace List Data : $trackExercise");
                      print("Length4 : ${trackExerciseList.length}");
                    }
                  }
                }

                for (int i = 0; i < trackExerciseList.length; i++) {
                  if (exercise.id == trackExerciseList[i].id) {
                    widget.exData.sets![0].time = trackExerciseList[i].totalTime;
                    widget.exData.sets![0].status = trackExerciseList[i].status;
                    widget.addEx(data: widget.exData);

                    print("ADD EX : ${widget.addEx}");
                    setState(() {});
                  }
                }
              }
            });
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
              const SizedBox(height: 4),
              widget.exData.sets![0].status != null ?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child:  Row(
                  children: [
                    Text("Status : ${widget.exData.sets![0].status}"),
                  ],
                ),
              ) : const SizedBox(),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );

    // return CheckboxListTile(
    //     contentPadding: const EdgeInsets.symmetric(horizontal: 5),
    //     value: checkboxValue,
    //     onChanged: (value) {
    //       for (int i = 0; i < trackExerciseList.length; i++) {
    //         if (exercise.id == trackExerciseList[i].id) {
    //           widget.exData.sets![0].time = trackExerciseList[i].totalTime;
    //           setState(() {
    //             checkboxValue = !checkboxValue;
    //           });
    //         }
    //       }
    //       if (checkboxValue) {
    //         widget.addEx(data: widget.exData);
    //       } else {
    //         widget.removeEx(data: widget.exData);
    //       }
    //     },
    //     title: buildWidget(exercise));
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

class TrackExercise {
  String? id;
  String? name;
  String? exerciseStartTime;
  String? exerciseEndTime;
  String? totalTime;
  String? status;

  TrackExercise(
      {this.id,
      this.name,
      this.exerciseEndTime,
      this.status,
      this.exerciseStartTime,
      this.totalTime});
}
