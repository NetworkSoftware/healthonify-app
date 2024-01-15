import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/trackers/steps_tracker.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/screens/client_screens/reminders/steps_reminder.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/step_tracker/change_steps_goal.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/step_tracker/steps_graph.dart';
import 'package:healthonify_mobile/widgets/cards/change_goal.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/cards/health_app_sync_card.dart';
import 'package:healthonify_mobile/widgets/cards/reminder_card.dart';
import 'package:healthonify_mobile/widgets/cards/steps_screen_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StepsScreen extends StatefulWidget {
  const StepsScreen({Key? key}) : super(key: key);

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  bool isLoading = false;
  late String date;

  Future<String?> getSteps(BuildContext context) async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      date = await Provider.of<StepTrackerProvider>(context, listen: false)
          .getStepsCount(userId!);
      print("Date : $date");
      return date;
    } on HttpException catch (e) {
      log(e.toString());
      return null;
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      log("Error getting steps count in steps screen: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    date = DateFormat("MM/dd/yyyy").format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Steps',
      ),
      body: FutureBuilder(
        future: getSteps(context),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Consumer<StepTrackerProvider>(
                        builder: (context, value, child) {
                          if(value.stepsData.isNotEmpty){
                            print("Stepcount : ${value.stepsData.first.stepsCount!}");
                            return StepsScreenCard(
                              goal: value.stepsData.last.goalCount!,
                              stepCount: value.stepsData.last.stepsCount,
                              startDate: date,
                            );
                          }else{
                            return StepsScreenCard(
                              goal: 0,
                              startDate: date,
                            );
                          }

                        }),
                    const SizedBox(height: 14),
                    //const SyncHealthAppCard(),
                    Consumer<StepTrackerProvider>(
                        builder: (context, value, child) {
                          return Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                            child: StepsGraphCard(
                              goal: value.stepsData.isNotEmpty ? value.stepsData.last.goalCount! : 0,
                              stepCount: value.stepsData.isNotEmpty ? value.stepsData.last.stepsCount : 0,
                            ),
                          );

                        }),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChangeGoalCard(
                          icon: Icons.directions_walk_outlined,
                          onClick: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Consumer<AllTrackersData>(
                                  builder: (context, value, child) =>
                                      ChangeStepsGoal(
                                          goal: value
                                              .allTrackersData.totalStepsGoal!),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ReminderCard(
                      route: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const StepsReminders();
                        }));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        '''Walking is a really good form of exercise and can help you reach your fitness and weight-loss goals. Meeting your step count each day takes dedication and discipline. It also requires a commitment from you to put your health first. Make walking a daily part of your routine and get going.''',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: const Color(0xFF000080),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    stepsTable(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }

  Widget stepsTable(context) {
    var tableTextStyle = Theme.of(context).textTheme.bodySmall;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Table(
              border: TableBorder.all(
                color: Theme.of(context).textTheme.bodySmall!.color!,
              ),
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Activity Level', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Daily Steps', style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Inactive(Sedentary)', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Less than 5000 steps per day',
                          style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child:
                          Text('Average(Low Activity)', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('5000-7500 steps per day',
                          style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Somewhat Active', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('7500-10000 steps per day',
                          style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Active', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('10000-12500 steps per day',
                          style: tableTextStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Highly Active', style: tableTextStyle),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Above 12500 steps per day',
                          style: tableTextStyle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
