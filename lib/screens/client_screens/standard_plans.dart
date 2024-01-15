import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';

import 'package:healthonify_mobile/screens/client_screens/my_workout/track_workout/track_wk_days.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

enum PopUp { start, edit, copy }

class StandardPlans extends StatefulWidget {
  final WorkoutModel workoutModel;
  const StandardPlans({Key? key, required this.workoutModel}) : super(key: key);

  @override
  State<StandardPlans> createState() => _StandardPlansState();
}

class _StandardPlansState extends State<StandardPlans> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Free Workout Plans',
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  workoutCard(widget.workoutModel),
                ],
              ),
            ),
    );
  }

  Widget workoutCard(WorkoutModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => TrackWkDays(
                      workoutModel: model,
                    )),
          );
        },
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            model.name!,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        PopupMenuButton(
                          color: Theme.of(context).canvasColor,
                          icon: Icon(
                            Icons.more_vert,
                            color: Theme.of(context).colorScheme.onBackground,
                            size: 26,
                          ),
                          onSelected: (item) {
                            if (item == PopUp.start) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => TrackWkDays(
                                          workoutModel: model,
                                        )),
                              );
                            }
                          },
                          itemBuilder: (context) {
                            return <PopupMenuEntry<PopUp>>[
                              PopupMenuItem(
                                value: PopUp.start,
                                child: Text(
                                  'Start',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ];
                          },
                          splashRadius: 20,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        model.description!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(
                                  model.daysInweek!,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  'No of days in a week',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.grey,
                            indent: 10,
                            endIndent: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Text(
                                  "${model.validityInDays!} days",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  'Duration',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "Exercises",
            //         style: Theme.of(context).textTheme.headlineMedium,
            //       ),
            //       if (widget.workoutModel.schedule != null &&
            //           widget.workoutModel.schedule!.isNotEmpty)
            //         ListView.builder(
            //           shrinkWrap: true,
            //           itemCount: widget.workoutModel.schedule!.length,
            //           itemBuilder: (context, index) {
            //             var schedule = widget.workoutModel.schedule![index];
            //             return Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 const SizedBox(
            //                   height: 10,
            //                 ),
            //                 Text(
            //                   "Day ${index + 1}",
            //                   style: Theme.of(context).textTheme.labelLarge,
            //                 ),
            //                 if (schedule.exercises != null &&
            //                     schedule.exercises!.isNotEmpty)
            //                   ListView.builder(
            //                     shrinkWrap: true,
            //                     itemCount: schedule.exercises!.length,
            //                     itemBuilder: (context, index) => Text(
            //                         "${index + 1}. ${schedule.exercises![index].exerciseId!["name"]}"),
            //                   )
            //               ],
            //             );
            //           },
            //         ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
