import 'package:flutter/material.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/screens/client_screens/reminders/water_reminder.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/watertracker/change_water_goal.dart';
import 'package:healthonify_mobile/widgets/cards/average_water_card.dart';
import 'package:healthonify_mobile/widgets/cards/change_goal.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/cards/reminder_card.dart';
import 'package:healthonify_mobile/widgets/cards/water_details_card.dart';
import 'package:provider/provider.dart';

class WaterTrackerScreen extends StatefulWidget {
  // final Function returnWaterGlass;
  const WaterTrackerScreen({
    Key? key,
    // required this.returnWaterGlass,
  }) : super(key: key);

  @override
  State<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends State<WaterTrackerScreen> {
  String? dropdownValue;
  List dropDownOptions = [
    'This Week',
    'This Month',
    'Last 2 months',
    'Last 3 months',
  ];

  @override
  Widget build(BuildContext context) {
    String? goalCount = Provider.of<AllTrackersData>(context)
        .allTrackersData
        .totalWaterGoal!
        .toString();
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Water',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                'Log Water',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<AllTrackersData>(
                  builder: (context, value, child) => WaterCardDetails(
                    goalCount: goalCount,
                    // returnWaterGlass: widget.returnWaterGlass,
                    // returnWaterGlass: (){},
                    waterGlass:
                        value.allTrackersData.userWaterGlassCount.toString(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChangeGoalCard(
                    icon: Icons.local_drink,
                    onClick: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Consumer<AllTrackersData>(
                            builder: (context, value, child) => ChangeWaterGoal(
                              goal: value.allTrackersData.totalWaterGoal!,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            AverageWaterGraph(
              maxYcount: double.parse(goalCount),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReminderCard(
                  route: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const WaterReminders();
                    }));
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                '''Water is your body’s principal chemical component and makes up about 50% to 70% of your body weight. Your body depends on water to survive. Every cell, tissue and organ in your body needs water to work properly. Lack of water can lead to dehydration — a condition that occurs when you don’t have enough water in your body to carry out normal functions. Even mild dehydration can drain your energy and make you tired. The U.S. National Academies of Sciences, Engineering, and Medicine determined that an adequate daily fluid intake is: 
 About 3.7L of fluids a day for men 
 About 2.7L of fluids a day for women.

              These recommendations cover fluids from water, other beverages and food. About 20% of daily fluid intake usually comes from food and the rest from drinks. A minimum of 2L of daily water consumption is considered to be the desired intake of water for our body.''',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: const Color(0xFF000080),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
