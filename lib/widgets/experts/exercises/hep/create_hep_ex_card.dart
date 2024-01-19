import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/exercise/exercise.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/exercises/expert_exercise_details.dart';

class CreateHepExCard extends StatefulWidget {
  final ExerciseWorkoutModel exData;
  final Function deleteExercise;
  const CreateHepExCard({
    Key? key,
    required this.exData,
    required this.deleteExercise,
  }) : super(key: key);

  @override
  State<CreateHepExCard> createState() => _CreateHepExCardState();
}

class _CreateHepExCardState extends State<CreateHepExCard> {
  @override
  Widget build(BuildContext context) {
    Exercise exercise = Exercise(
      id: widget.exData.exerciseId!["_id"],
      bodyPartGroupId: [
        widget.exData.bodyPartGroupId
      ],
      // bodyPartGroupId: [
      //   {
      //     "name": widget.exData.bodyPartGroupId!["name"],
      //     "id": widget.exData.bodyPartGroupId!["_id"],
      //   }
      // ],
      bodyPartId: [
        {
          "name": widget.exData.bodyPartId!["name"],
          "id": widget.exData.bodyPartId!["_id"],
        }
      ],
    );

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
                          sets: const [],
                          // sets: widget.exData.sets!.length.toString(),
                          // reps: widget.exData.sets![0].reps!,
                        )))
                .then((value) {
              if (value != null) {
                log("ex sets and reps $value");
                List<Set> sets = List.generate(
                    int.parse(value["sets"]),
                    (index) => Set(
                          reps: value["reps"],
                          weight: widget.exData.sets![0].weight,
                          weightUnit: widget.exData.sets![0].weightUnit,
                        ));
                setState(() {
                  widget.exData.sets = sets;
                });
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
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Row(
                          //   children: [
                          //     Text("Sets : ${widget.exData.sets!.length}"),
                          //     const SizedBox(
                          //       width: 5,
                          //     ),
                          //     Text("Reps : ${widget.exData.sets![0].reps}"),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 120,
                        width: 130,
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
                      const Row(
                        children: [
                          Icon(Icons.videocam),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Ankle"),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.home_repair_service),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(exercise.bodyPartGroupId![0]["name"]),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          widget.deleteExercise();
                        },
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          radius: 15,
                          child: const Icon(
                            Icons.delete,
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
}
