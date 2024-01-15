import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/func/string_date_format.dart';
import 'package:healthonify_mobile/func/trackers/sleep_tracker_func.dart';
import 'package:healthonify_mobile/models/all_trackers.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class SleepDetailsCard extends StatefulWidget {
  const SleepDetailsCard({
    Key? key,
  }) : super(key: key);

  @override
  State<SleepDetailsCard> createState() => _SleepDetailsCardState();
}

class _SleepDetailsCardState extends State<SleepDetailsCard> {
  Future<void> getSleepLogs(BuildContext context) async {
    await SleepTrackerFunc().getSleepLogs(context);
  }

  String setData(AsyncSnapshot snapshot, AllTrackers sleepData) {
    String value = "0";
    if (snapshot.connectionState == ConnectionState.waiting) {
      value = "0";
      // log("Hello");
    } else {
      if (sleepData.userSleepCount != 0 && sleepData.totalSleepGoal != 0) {
        // value = StringDateTimeFormat()
        //     .subtractTime(sleepData[0].sleepTime!, sleepData[0].wakeupTime!);
        double v;

        v = sleepData.userSleepCount! / 60;

        value = v.toString();
        log("data $value");
      } else {
        value = "0";
      }
      // log("Hello 3");

    }
    return value;
  }

  double calculatePercent(
      AsyncSnapshot snapshot, String todaySlept, String goal) {
    double percent = 0.0;
    if (snapshot.connectionState == ConnectionState.waiting) {
      percent = 0.0;
    } else {
      if (todaySlept == "0") {
        percent = 0;
      } else {
        double totalSleptHours = double.parse(todaySlept);
        int totalGoalHours = StringDateTimeFormat().convertHoursToMins(goal);

        log("Data $totalGoalHours");

        percent = totalSleptHours > totalGoalHours
            ? 1
            : totalSleptHours / totalGoalHours;
      }
    }
    log(percent.toString());
    return percent;
  }

  String? sleepGoal;

  String temp(AsyncSnapshot snapshot, AllTrackers data) {
    String totalSleepGoal = "0h", goalSleep = "0h";

    print("............... : ${data.userSleepCount}");

    if (snapshot.connectionState == ConnectionState.waiting) {
    } else {

      // set sleep data
      int totalSleepHrs = (data.totalSleepGoal! ~/ 3600);
      int totalSleepMins = (data.totalSleepGoal!.remainder(3600) ~/ 60);
      if (totalSleepMins != 0 && totalSleepHrs != 0) {
        totalSleepGoal = "${totalSleepHrs}h ${totalSleepMins}m";
      } else if (totalSleepMins != 0 && totalSleepHrs == 0) {
        totalSleepGoal = "$totalSleepMins m";
      } else {
        totalSleepGoal = "$totalSleepHrs h";
      }
      sleepGoal = totalSleepGoal;
      // log(totalSleepMins.toString());

      print("data.totalSleepGoal : ${data.userSleepCount}");
      int goalSleepMins = data.userSleepCount!.remainder(3600) ~/ 60;
      int goalSleepHrs = (data.userSleepCount! ~/ 3600);

      if (goalSleepMins != 0 && goalSleepHrs != 0) {
        goalSleep = "${goalSleepHrs}h ${goalSleepMins}m";
      } else if (goalSleepMins != 0 && goalSleepHrs == 0) {
        goalSleep = "$goalSleepMins m";
      } else {
        goalSleep = "${goalSleepHrs}h";
      }
    }
   

    return goalSleep;
  }

  @override
  Widget build(BuildContext context) {
    String sleepTime = Provider.of<UserData>(context).userData.sleepTime!;
    String wakeupTime = Provider.of<UserData>(context).userData.wakeupTime!;
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;

    AllTrackers data = Provider.of<AllTrackersData>(context).allTrackersData;

    return sleepTime.isEmpty || wakeupTime.isEmpty
        ? Container()
        : FutureBuilder(
            future: getSleepLogs(context),
            builder: (context, snapshot) {
              String todaySlept = setData(snapshot, data);
              String todaySleptFormatted = temp(snapshot, data);

              print("todaySleptFormatted : $todaySleptFormatted");

              String totalSleepGoal =
                  StringDateTimeFormat().subtractTime(sleepTime, wakeupTime);
              double percent =
                  calculatePercent(snapshot, todaySlept, totalSleepGoal);
              return SizedBox(
                height: 120,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Today',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Row(
                          children: [
                            Text(
                              todaySleptFormatted,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              ' of $sleepGoal',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: LinearPercentIndicator(
                            percent: percent,
                            progressColor: const Color(0xFF8E4CED),
                            backgroundColor: Colors.white,
                            animation: true,
                            animationDuration: 1500,
                            lineHeight: 7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
