import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/placeholder_images.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/exercise/exercise.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/workout/set_type_models.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/providers/exercises/exercises_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/exercises/expert_exercise_details.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/add_sets_bottomsheet.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExerciseDetailsCard extends StatefulWidget {
  final Exercise exData;
  final bool isSelectEx;
  final bool isImagePresentAndClickable;
  final String userWeight;
  const ExerciseDetailsCard(
      {Key? key,
      required this.exData,
      this.isSelectEx = false,
      this.userWeight = "0",
      this.isImagePresentAndClickable = true})
      : super(key: key);

  @override
  State<ExerciseDetailsCard> createState() => _ExerciseDetailsCardState();
}

class _ExerciseDetailsCardState extends State<ExerciseDetailsCard> {
  @override
  Widget build(BuildContext context) {
    // List<Set> sets = [];
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: !widget.isImagePresentAndClickable
              ? () {
                  showExCalculatorDialog();
                }
              : () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => ExerciseDetailsScreen(
                        exerciseData: widget.exData,
                        sets: const [],
                        // sets: sets.length.toString(),
                        // reps: sets.isEmpty ? "0" : sets[0].reps ?? "0",
                      ),
                    ),
                  )
                      .then((value) {
                    if (value != null) {
                      log("ex sets and reps $value");
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
                            widget.exData.name!,
                            style: Theme.of(context).textTheme.labelLarge,
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
                        ],
                      ),
                    ),
                    if (widget.isImagePresentAndClickable)
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 120,
                          width: 130,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: widget.exData.mediaLink == null ||
                                        widget.exData.mediaLink!.isEmpty
                                    ? NetworkImage(placeholderImg)
                                        as ImageProvider
                                    : CachedNetworkImageProvider(
                                        widget.exData.mediaLink!),
                                fit: BoxFit.cover),
                          ),
                        ),
                      )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: Theme.of(context).canvasColor,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.videocam),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(widget.exData.bodyPartId == null ||
                                  widget.exData.bodyPartId!.isEmpty
                              ? ""
                              : widget.exData.bodyPartId![0]["name"] ?? ""),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.home_repair_service),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(widget.exData.bodyPartGroupId == null ||
                                  widget.exData.bodyPartGroupId!.isEmpty
                              ? ""
                              : widget.exData.bodyPartGroupId![0]["name"] ??
                                  ""),
                        ],
                      ),
                      if (widget.isSelectEx)
                        InkWell(
                          onTap: () {
                            // if (!widget.isSelectEx) {
                            //   showDialog(
                            //       context: context,
                            //       builder: (context) => const AddExcDialog());
                            // } else {
                            showAddExerciseDialog(context, widget.exData);
                            // showDialog(
                            //   context: context,
                            //   builder: (context) => AddExcToHepDialog(
                            //     onSubmit: (AddSetsModel sets) {
                            //       ExerciseWorkoutModel model =
                            //           ExerciseWorkoutModel(
                            //         bodyPartGroupId: exData.bodyPartGroupId![0],
                            //         bodyPartId: exData.bodyPartId![0],
                            //         exerciseId: {
                            //           "name": exData.name,
                            //           "mediaLink": exData.mediaLink,
                            //           "_id": exData.id
                            //         },
                            //         sets: List.generate(
                            //           sets.sets!,
                            //           (index) => Set(
                            //             reps: sets.reps.toString(),
                            //           ),
                            //         ),
                            //       );
                            //       Navigator.of(context).pop(
                            //         model,
                            //       );
                            //     },
                            //   ),
                            // );
                          },
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            radius: 15,
                            child: const Icon(
                              Icons.add,
                              size: 20,
                              color: whiteColor,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showAddExerciseDialog(
    context,
    Exercise exercise,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        print("Body : ${exercise.bodyPartId![0]}");
        return AddSetsBottomsheet(
          exerciseName: exercise.name,
          saveData: (Map<String, dynamic> data) {
            ExerciseWorkoutModel model = ExerciseWorkoutModel(
              round: data["sequence"],
              group: data["exGroup"],
              //bodyPartGroupId: exercise.bodyPartGroupId![0],
              bodyPartId: exercise.bodyPartId![0],
              setType: getSetType(data["sets"]),
              exerciseId: {
                "name": exercise.name,
                "mediaLink": exercise.mediaLink,
                "_id": exercise.id
              },
              note: data["setsNote"],
              sets: setSets(
                data["sets"],
              ),
            );
            // log(model.sets![0].weight!);
            Navigator.of(context).pop(
              model,
            );
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
          speed: tempData[index].timeUnit,
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

  showExCalculatorDialog() {
    // set up the AlertDialog

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShowExCalculatorDialog(
          title: widget.exData.name ?? "",
          calorieFactor: widget.exData.calorieFactor ?? 0.0,
          currentWeight: widget.userWeight,
          exId: widget.exData.id!,
        );
      },
    );
  }
}

class ShowExCalculatorDialog extends StatefulWidget {
  final String title;
  final double calorieFactor;
  final String currentWeight;
  final String exId;
  const ShowExCalculatorDialog(
      {super.key,
      required this.title,
      required this.calorieFactor,
      required this.exId,
      required this.currentWeight});

  @override
  State<ShowExCalculatorDialog> createState() => _ShowExCalculatorDialogState();
}

class _ShowExCalculatorDialogState extends State<ShowExCalculatorDialog> {
  double caloriesBurnt = 0;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Map data = {
    "userId": "",
    "date": "",
    "weight": "",
    "exerciseId": "",
    "durationInMinutes": "",
  };
  Future<void> postEx() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String userId = Provider.of<UserData>(context, listen: false).userData.id!;

    data["userId"] = userId;
    data["date"] = DateFormat("yyyy-MM-dd").format(DateTime.now());
    data["weight"] = widget.currentWeight;
    data["exerciseId"] = widget.exId;

    log("ex data : $data");

    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<ExercisesData>(context, listen: false).postExLog(data);
      Navigator.of(context).pop();
    } on HttpException catch (e) {
      log("error http post ex $e");
      Fluttertoast.showToast(msg: "Unable to save your exercise");
    } catch (e) {
      log("Error post ex  $e");
      Fluttertoast.showToast(msg: "Unable to save your exercise");
    } finally {
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Minutes Performed",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              onChanged: (value) {
                if (value.isEmpty) {
                  value = "0";
                }
                setState(() {
                  int mins = int.parse(value);
                  caloriesBurnt = (mins *
                      widget.calorieFactor *
                      double.parse(widget.currentWeight));
                  data["durationInMinutes"] = value;
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter the minutes performed",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1.25,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a value";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Calories burnt",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(caloriesBurnt.toStringAsFixed(2)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading
              ? null
              : () {
                  Navigator.of(context).pop();
                },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: isLoading
              ? null
              : () async {
                  await postEx();
                },
          child: const Text("OK"),
        ),
      ],
    );
  }
}
