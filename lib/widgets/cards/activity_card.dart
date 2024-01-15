import 'dart:developer';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/all_trackers.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:provider/provider.dart';

class ActivityCard extends StatefulWidget {
  const ActivityCard({Key? key}) : super(key: key);

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
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

  List<Map<String, dynamic>> data = [];

  void setData(WeeklyWorkoutsModel weeklyWorkoutsModel) {
    data.clear();
    if (weeklyWorkoutsModel.weeklyData == null) {
      return;
    }
    for (var element in weeklyWorkoutsModel.weeklyData!) {
      DateTime date = DateFormat("yyyy-MM-dd").parse(element.date!);
      // print(DateFormat("EEE").format(date));
      data.add({
        "day": DateFormat("EEE").format(date),
        "checkedIn": element.checkedIn ?? false,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWeeklyAcitivity(),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const SizedBox()
          : SizedBox(
              width: MediaQuery.of(context).size.width * 0.98,
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "This week's activity",
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      SizedBox(
                        height: 85,
                        width: double.infinity,
                        child: ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (context, index) => SizedBox(
                            height: 86,
                            width: 54,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  data[index]["checkedIn"]
                                      ? Icons.check_circle
                                      : Icons.cancel_rounded,
                                  color: orange,
                                  size: 28,
                                ),
                                Text('${data[index]["day"]}'),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
