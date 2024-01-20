import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/all_trackers.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:provider/provider.dart';

class TotalWorkoutHours extends StatefulWidget {
  const TotalWorkoutHours({Key? key}) : super(key: key);

  @override
  State<TotalWorkoutHours> createState() => _TotalWorkoutHoursState();
}

class _TotalWorkoutHoursState extends State<TotalWorkoutHours> {
  Future<void> getWeeklyAcitivity() async {
    Map<String, dynamic> data = {
      "userId": Provider.of<UserData>(context, listen: false).userData.id,
      "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
    };
    try {
      WeeklyWorkoutsModel weeklyWorkoutsModel =
          await Provider.of<AllTrackersData>(context, listen: false)
              .getWeeklyActivity(data);
      setData(weeklyWorkoutsModel);
      log("fetched weekly data");
    } on HttpException catch (e) {
      log("Error getting weekly activity http $e");
      Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log("Error getting weekly activity $e");
      Fluttertoast.showToast(msg: "Unable to fetch diet plans");
    } finally {}
  }

  String totalWorkoutHours = "0";
  int totalCheckins = 0;

  void setData(WeeklyWorkoutsModel weeklyWorkoutsModel) {
    if (weeklyWorkoutsModel.weeklyData == null) {
      return;
    }

    totalWorkoutHours = ((weeklyWorkoutsModel.weeklyDurationInMinutes! / 60))
        .toStringAsFixed(2);

    for (var element in weeklyWorkoutsModel.weeklyData!) {
      if (element.checkedIn ?? false) {
        totalCheckins++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWeeklyAcitivity(),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const SizedBox()
              : Row(
                  children: [
                    SizedBox(
                      height: 164,
                      width: MediaQuery.of(context).size.width * 0.48,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.schedule,
                              color: Colors.orange,
                              size: 54,
                            ),
                            Text(
                              totalWorkoutHours,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            Text(
                              'Total Workout Hours',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 164,
                      width: MediaQuery.of(context).size.width * 0.48,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.blue,
                              size: 54,
                            ),
                            Text(
                              '$totalCheckins',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            Text(
                              'Total Check ins',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
    );
  }
}
