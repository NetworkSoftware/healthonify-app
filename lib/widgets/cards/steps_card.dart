import 'package:flutter/material.dart';
import 'package:healthonify_mobile/func/trackers/steps_tracker_func.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/step_tracker/steps_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'dart:developer';
import 'package:healthonify_mobile/func/trackers/step_tracker.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:provider/provider.dart';

class StepsCard extends StatefulWidget {
  const StepsCard({
    Key? key,
  }) : super(key: key);

  @override
  State<StepsCard> createState() => _StepsCardState();
}

class _StepsCardState extends State<StepsCard> {
  StepTrackerData stepsData = StepTrackerData();
  int goal = 0;

  Future<void> getSteps(
      BuildContext context, int goal, VoidCallback onSuccess) async {
    try {
      DateTime startDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      stepsData = await StepTracker().initHealth(goal, startDate);
      if (stepsData.stepCount != null && stepsData.stepCount != "null") {
        log(stepsData.stepCount.runtimeType.toString());
        log("step data ${stepsData.stepCount}");
        onSuccess.call();
        setState(() {});
      }
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error steps screen $e");
      // Fluttertoast.showToast(msg: "Unable to fetch water intake data");
    }
  }

  @override
  void initState() {
    super.initState();
    goal = Provider.of<AllTrackersData>(context, listen: false)
            .allTrackersData
            .totalStepsGoal ??
        0;
    getSteps(
      context,
      goal,
      () => StepsTrackerFunc().updateSteps(
          context,
          stepsData.stepsData!,
          () => Provider.of<AllTrackersData>(context, listen: false)
              .localUpdateSteps(int.parse(stepsData.stepCount!))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: SizedBox(
          height: 125,
          width: MediaQuery.of(context).size.width * 0.98,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const StepsScreen();
                    },
                  ),
                );
              },
              borderRadius: BorderRadius.circular(13),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          'Steps',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Image.asset(
                            'assets/icons/footsteps-silhouette-variant.png',
                            height: 19,
                            width: 19,
                          ),
                        ),
                        // ignore: prefer_const_constructors
                        Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xFFFF6666),
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stepsData.stepCount != null &&
                                          stepsData.stepCount != "null"
                                      ? stepsData.stepCount!
                                      : "0",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  'of $goal steps walked',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                            Text(
                              stepsData.stepCount != null &&
                                      stepsData.stepCount != "null"
                                  ? stepsToCal(stepsData.stepCount!)
                                  : "0 Kcal",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: LinearPercentIndicator(
                          percent: stepsData.percent != null
                              ? stepsData.percent!
                              : 0.0,
                          progressColor: const Color(0xFF0C9DE9),
                          backgroundColor: Colors.white,
                          animation: true,
                          animationDuration: 2000,
                          lineHeight: 7,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String stepsToCal(String steps) {
    double cal = int.parse(steps) * 0.04;
    return "${cal.toStringAsFixed(2)} Kcal";
  }
}
