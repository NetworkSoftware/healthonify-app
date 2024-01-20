import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/placeholder_images.dart';
import 'package:healthonify_mobile/models/exercise/exercise.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

import 'package:healthonify_mobile/widgets/experts/exercises/exercise_directions_card.dart';

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
  // void getReps(value) {
    
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: "",
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
        ExerciseDirectionsCard(exerciseData: widget.exerciseData,),
        const SizedBox(
          height: 10,
        )
      ]),
    );
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
}

// Widget editBtn(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.only(right: 8.0, top: 10, bottom: 10),
//     child: TextButton(
//       child: Row(
//         children: const [
//           Text("Edit"),
//         ],
//       ),
//       style: TextButton.styleFrom(),
//       onPressed: () {},
//     ),
//   );
// }

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
                  // Row(
                  //   children: const [
                  //     Icon(Icons.flash_on),
                  //     Text("Active ROM"),
                  //   ],
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     TextButton.icon(
              //       icon: const Icon(Icons.check),
              //       onPressed: () {},
              //       label: const Text("Correct"),
              //     ),
              //     TextButton.icon(
              //       icon: const Icon(Icons.close),
              //       onPressed: () {},
              //       label: const Text("Wrong"),
              //     ),
              //   ],
              // ),
              const SizedBox(
                height: 15,
              ),
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
              const SizedBox(
                height: 20,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: const [
              //         Text("Sets"),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         // SetCounter(setCount: sets, getValue: getSets),
              //       ],
              //     ),
              //     const SizedBox(
              //       width: 30,
              //     ),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: const [
              //         Text("Reps"),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         // RepCounter(repsCount: reps, getRepsValue: getReps),
              //       ],
              //     ),
              //   ],
              // ),
              const SizedBox(
                height: 30,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: const [
              //         Text("Hold(secs)"),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         HoldCounter(),
              //       ],
              //     ),
              //     const SizedBox(
              //       width: 30,
              //     ),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: const [
              //         Text("Reset(secs)"),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         ResetCounter(),
              //       ],
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // const LeftAndRightBtns(),
              // const SizedBox(
              //   height: 20,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
