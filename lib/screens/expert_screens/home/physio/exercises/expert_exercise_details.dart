import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/placeholder_images.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/main.dart';
import 'package:healthonify_mobile/models/exercise/exercise.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/screens/client_screens/my_workout/track_workout/timer_card.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

import 'package:healthonify_mobile/widgets/experts/exercises/exercise_directions_card.dart';
import 'package:healthonify_mobile/widgets/experts/exercises/hep/edit_hep_plan.dart';
import 'package:intl/intl.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  final Exercise exerciseData;

  // final List<Set> sets;
  final List<Set> sets;

  const ExerciseDetailsScreen({
    Key? key,
    required this.exerciseData,
    required this.sets,
  }) : super(key: key);

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  final Dependencies dependencies = Dependencies();
  int? milliseconds;
  Timer? timer;
  int hundreds = 0;

  TrackExercise? trackExercise;
  final Map<String, String> data = {
    "id": "",
    "name": "",
    "exerciseStartTime": "",
    "exerciseEndTime": "",
    "totalTime": "",
    "status": "",
  };

  void setData(String time) {
    data["exerciseEndTime"] =
        DateFormat('dd-MM-yyyy hh:mm:ss').format(DateTime.now());
    data["totalTime"] = time;
    data["status"] = "Finished";
    kSharedPreferences.setString("ExerciseData", json.encode(data));
  }

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.hundreds != hundreds) {
      setState(() {
        hundreds = elapsed.hundreds!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: orange,
          title: Text(
            '',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: whiteColor),
          ),
          actions: [
            dependencies.stopwatch.isRunning
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RepaintBoundary(
                          child: SizedBox(
                            child:
                                MinutesAndSeconds(dependencies: dependencies),
                          ),
                        ),
                        RepaintBoundary(
                          child: SizedBox(
                            child: Hundreds(dependencies: dependencies),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox()
          ],
          leading: dependencies.stopwatch.isRunning
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    color: whiteColor,
                    size: 40,
                  ),
                  splashRadius: 20,
                ),
          shadowColor: Colors.transparent,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: orange,
          icon: dependencies.stopwatch.isRunning
              ? const Icon(Icons.stop, color: whiteColor)
              : const Icon(Icons.play_arrow, color: whiteColor),
          label: Text(
              dependencies.stopwatch.isRunning
                  ? 'End Workout'
                  : 'Start Workout',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: whiteColor, fontWeight: FontWeight.bold)),
          onPressed: () {
            setState(() {
              if (dependencies.stopwatch.isRunning) {
                dependencies.stopwatch.stop();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: const Text('Do you wish to end this workout?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          dependencies.stopwatch.start();
                        },
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () {
                          var data = dependencies.stopwatch.elapsedMilliseconds;
                          int minutes = (data / 60000).ceil();
                          //saveTime(minutes.toString());
                          setData(minutes.toString());
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              } else {
                dependencies.stopwatch.start();
                timer = Timer.periodic(
                    Duration(
                        milliseconds: dependencies
                            .timerMillisecondsRefreshRate),
                    callback);
                data["id"] = widget.exerciseData.id!;
                data["name"] = widget.exerciseData.name!;
                data["exerciseStartTime"] =
                    DateFormat('dd-MM-yyyy hh:mm:ss')
                        .format(DateTime.now());
                data["status"] = "InProgress";

                kSharedPreferences.setString(
                    "ExerciseData", json.encode(data));
              }
            });
          },
        ),
        body: ListView(children: [
          ExDetailsCard(
            bodypart: widget.exerciseData.bodyPartId == null ||
                    widget.exerciseData.bodyPartId!.isEmpty
                ? ""
                : widget.exerciseData.bodyPartId![0]["name"],
            bodyCategory: widget.exerciseData.bodyPartGroupId == null ||
                    widget.exerciseData.bodyPartGroupId!.isEmpty
                ? ""
                : widget.exerciseData.bodyPartGroupId![0]["name"],
            mediaLink: widget.exerciseData.mediaLink,
            title: widget.exerciseData.name,
          ),
          ExContainer(
            mediaLink: widget.exerciseData.mediaLink,
          ),
          if (widget.sets.isNotEmpty) exerciseSetDetails(),
          dependencies.stopwatch.isRunning ? exerciseAlertCard() : const SizedBox(),
          ExerciseDirectionsCard(
            exerciseData: widget.exerciseData,
          ),
          const SizedBox(
            height: 10,
          )
        ]),
      ),
    );
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds! / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  Widget iconBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 10, bottom: 10),
      child: TextButton(
        style: TextButton.styleFrom(),
        onPressed: () {
          // Navigator.of(context).pop({"sets": sets, "reps": reps});
        },
        child: Row(
          children: [
            const Text("Add"),
            Icon(
              Icons.add,
              size: 20,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget exerciseSetDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.sets.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Set ${index + 1}"),
                const SizedBox(
                  height: 10,
                ),
                if (widget.sets[index].weight != null &&
                    widget.sets[index].weight != "0" &&
                    widget.sets[index].weight!.isNotEmpty)
                  Row(
                    children: [
                      Text("Weight : ${widget.sets[index].weight!}"),
                      Text(widget.sets[index].weightUnit!),
                    ],
                  ),
                if (widget.sets[index].distance != null &&
                    widget.sets[index].distance != "0" &&
                    widget.sets[index].distance!.isNotEmpty)
                  Row(
                    children: [
                      Text("Distance : ${widget.sets[index].distance!}"),
                      Text(widget.sets[index].distanceUnit!),
                    ],
                  ),
                if (widget.sets[index].time != null &&
                    widget.sets[index].time != "0" &&
                    widget.sets[index].time!.isNotEmpty)
                  Row(
                    children: [
                      Text("Time : ${widget.sets[index].time!}"),
                      Text(widget.sets[index].timeUnit!),
                    ],
                  ),
                if (widget.sets[index].speed != null &&
                    widget.sets[index].speed != "0" &&
                    widget.sets[index].speed!.isNotEmpty)
                  Row(
                    children: [
                      Text("Speed : ${widget.sets[index].speed!}"),
                    ],
                  ),
                if (widget.sets[index].name != null &&
                    widget.sets[index].name != "0" &&
                    widget.sets[index].name!.isNotEmpty)
                  Row(
                    children: [
                      Text("Name : ${widget.sets[index].name!}"),
                    ],
                  ),
                if (widget.sets[index].set != null &&
                    widget.sets[index].set != "0" &&
                    widget.sets[index].set!.isNotEmpty)
                  Row(
                    children: [
                      Text("Set : ${widget.sets[index].set!}"),
                    ],
                  ),
                if (widget.sets[index].reps != null &&
                    widget.sets[index].reps != "0" &&
                    widget.sets[index].reps!.isNotEmpty)
                  Text("Reps : ${widget.sets[index].reps!}"),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget exerciseAlertCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            "Note : You can't go back until you finish the workout.",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

class ExDetailsCard extends StatelessWidget {
  final String? title, bodypart, bodyCategory, mediaLink;

  const ExDetailsCard(
      {Key? key,
      required this.title,
      required this.bodyCategory,
      required this.mediaLink,
      required this.bodypart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 4,
                    child: Text(
                      title ?? "",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Text(
                      bodypart ?? "",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
              // Text(mediaLink!),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.subtitles),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(bodyCategory ?? ""),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ExContainer extends StatelessWidget {
  final String? mediaLink;

  const ExContainer({
    Key? key,
    required this.mediaLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: mediaLink == null || mediaLink!.isEmpty
                          ? NetworkImage(placeholderImg) as ImageProvider
                          : CachedNetworkImageProvider(mediaLink!),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
