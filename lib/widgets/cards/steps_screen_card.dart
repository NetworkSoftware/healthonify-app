// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/func/trackers/step_tracker.dart';
import 'package:healthonify_mobile/func/trackers/steps_tracker_func.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class StepsScreenCard extends StatefulWidget {
  final int goal;
  final int? stepCount;
  final String startDate;

  const StepsScreenCard(
      {Key? key, required this.goal, required this.startDate, this.stepCount})
      : super(key: key);

  @override
  State<StepsScreenCard> createState() => _StepsScreenCardState();
}

class _StepsScreenCardState extends State<StepsScreenCard> {
  StepTrackerData stepsData = StepTrackerData();

  Future<void> getSteps(
      BuildContext context, int goal, VoidCallback onSuccess) async {
    try {
      DateTime startDate = DateFormat("MM/dd/yyyy").parse(widget.startDate);

      log("start date ${startDate.toString()}");

      stepsData = await StepTracker().initHealth(goal, startDate);

      print("STEEEEp DATA : $stepsData");
      if (startDate.isBefore(DateTime.now()) ||
          stepsData.stepCount != null && stepsData.stepCount != "null") {
        log(stepsData.stepCount.runtimeType.toString());
        log("step data ${stepsData.stepCount}");
        onSuccess.call();
      }
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error steps screen card $e");
      // Fluttertoast.showToast(msg: "Unable to fetch water intake data");
    }
  }

  @override
  void initState() {
    super.initState();

    print("Goal Step.....:${widget.goal}");
    print("Stepppppppppp.....:${widget.stepCount}");
    getSteps(
      context,
      widget.goal,
      () => StepsTrackerFunc().updateSteps(context, stepsData.stepsData!, () {
        log("stepsssss = ${stepsData.stepCount}");
        if (stepsData.stepCount != null && stepsData.stepCount != "null") {
          Provider.of<AllTrackersData>(context, listen: false)
              .localUpdateSteps(int.parse(stepsData.stepCount!));
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 90,
        //width: MediaQuery.of(context).size.width * 0.92,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) {
              //       return StepsScreen();
              //     },
              //   ),
              // );
            },
            borderRadius: BorderRadius.circular(13),
            child: Column(
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
                          // Text(
                          //   stepsData.stepCount != null &&
                          //           stepsData.stepCount != "null"
                          //       ? stepsData.stepCount!
                          //       : "0",
                          //   style: Theme.of(context).textTheme.titleLarge,
                          // ),
                          Text(
                            widget.stepCount == null ? "0" : widget.stepCount.toString(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            'of ${widget.goal} steps walked',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                      // Text(
                      //   stepsData.stepCount != null &&
                      //       stepsData.stepCount != "null"
                      //       ? stepsToCal(stepsData.stepCount!)
                      //       : "0.00 Kcal",
                      //   style: Theme.of(context).textTheme.bodyLarge,
                      // ),
                      Text(
                        widget.stepCount == null ? "0 Kcal" : stepsToCal(widget.stepCount.toString())
                        ,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: LinearPercentIndicator(
                    percent: stepsData.percent != null
                        ? stepsData.percent! > 1
                        ? 1
                        : stepsData.percent!
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
          ),
        ),
      ),
    );
  }

  String stepsToCal(String steps) {
    double cal = double.parse((int.parse(steps) * 0.04).toStringAsFixed(2));
    return "${cal.toString()} Kcal";
  }
}
