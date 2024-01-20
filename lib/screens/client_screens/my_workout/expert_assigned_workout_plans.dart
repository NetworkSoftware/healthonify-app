import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/workout_data.dart';
import 'package:healthonify_mobile/screens/client_screens/my_workout/track_workout/track_wk_days.dart';
import 'package:healthonify_mobile/screens/expert_screens/home/physio/hep/hep_days_plan_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

enum PopUp { edit, delete, copy, start }

class ExpertAssignedWorkoutPlans extends StatefulWidget {
  const ExpertAssignedWorkoutPlans({Key? key}) : super(key: key);

  @override
  State<ExpertAssignedWorkoutPlans> createState() =>
      _ExpertAssignedWorkoutPlansState();
}

class _ExpertAssignedWorkoutPlansState
    extends State<ExpertAssignedWorkoutPlans> {
  bool isLoading = false;
  List<WorkoutModel> workoutsList = [];

  Future<void> fetchWorkout() async {
    setState(() {
      isLoading = true;
    });
    var userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      workoutsList = await Provider.of<WorkoutProvider>(context, listen: false)
          .getUserWorkoutPlan("$userId");
      log('fetched workout detailss ${workoutsList.length}');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error getting workout details $e");
      Fluttertoast.showToast(msg: "Unable to fetch workout plans");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWorkout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Assigned Plans',
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : workoutsList.isEmpty
              ? const Center(
                  child: Text("No workouts available. Create one now."),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      searchBar(),
                      ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: workoutsList.length,
                        itemBuilder: (context, index) {
                          return workoutCard(workoutsList[index]);
                        },
                      ),
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
                builder: (context) => HepDaysPlanScreen(
                      workoutModel: model,
                      isEditEnabled: false,
                    )),
          );
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.name!,
                      style: Theme.of(context).textTheme.headlineSmall,
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
                          // PopupMenuItem(
                          //   value: PopUp.delete,
                          //   child: Text(
                          //     'Delete',
                          //     style: Theme.of(context).textTheme.bodyMedium,
                          //   ),
                          // ),
                          // PopupMenuItem(
                          //   value: PopUp.copy,
                          //   child: Text(
                          //     'Copy Plan',
                          //     style: Theme.of(context).textTheme.bodyMedium,
                          //   ),
                          // ),
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
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 4),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         flex: 1,
                //         child: Column(
                //           children: [
                //             Text(
                //               'Beginner',
                //               style: Theme.of(context).textTheme.labelMedium,
                //             ),
                //             const Text('Level'),
                //           ],
                //         ),
                //       ),
                //       const VerticalDivider(
                //         color: Colors.grey,
                //         indent: 10,
                //         endIndent: 10,
                //       ),
                //       Expanded(
                //         flex: 1,
                //         child: Column(
                //           children: [
                //             Text(
                //               'Fat Loss',
                //               style: Theme.of(context).textTheme.labelMedium,
                //             ),
                //             const Text('Goal'),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
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
                              style: Theme.of(context).textTheme.labelSmall,
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
                              style: Theme.of(context).textTheme.labelSmall,
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
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF717579),
          ),
          fillColor: Theme.of(context).canvasColor,
          filled: true,
          hintText: 'Search workout plan',
          hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: const Color(0xFF717579),
              ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          contentPadding: const EdgeInsets.all(0),
        ),
        style: Theme.of(context).textTheme.bodyMedium,
        cursorColor: whiteColor,
      ),
    );
  }
}
