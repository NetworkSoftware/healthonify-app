import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/workout/workout_model.dart';
import 'package:healthonify_mobile/providers/weight_management/workout_data.dart';
import 'package:healthonify_mobile/screens/client_screens/my_workout/track_workout/track_wk_days.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

class FreeWorkoutPlan extends StatefulWidget {
  const FreeWorkoutPlan({
    Key? key,
  }) : super(key: key);

  @override
  State<FreeWorkoutPlan> createState() => _FreeWorkoutPlanState();
}

class _FreeWorkoutPlanState extends State<FreeWorkoutPlan> {
  bool isLoading = false;
  List<WorkoutModel> workoutsList = [];

  Future<void> fetchWorkout() async {
    setState(() {
      isLoading = true;
    });
    // var userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      workoutsList = await Provider.of<WorkoutProvider>(context, listen: false)
          .getWorkoutPlan("?type=free");
      log('fetched workout details');
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
        appBarTitle: 'Free workout plans',
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
                builder: (context) => TrackWkDays(
                      workoutModel: model,
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
                    Expanded(
                      child: Text(
                        model.name!,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
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
      ),
    );
  }
}
