import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/reminders/sleep_reminder.dart';
import 'package:healthonify_mobile/screens/client_screens/trackers/sleep/add_sleep_log.dart';
import 'package:healthonify_mobile/widgets/cards/add_logs_card.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/cards/reminder_card.dart';
import 'package:healthonify_mobile/widgets/cards/sleep_chart_card.dart';
import 'package:healthonify_mobile/widgets/cards/sleep_details.dart';
import 'package:healthonify_mobile/widgets/cards/sleep_schedule_card.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        appBarTitle: 'Sleep',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SleepDetailsCard(),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SleepCardChart(),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const SleepInputCard(),
              ],
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Your schedule',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SleepScheduleCard(),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AddLogsCard(
                  onAdd: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddSleepLog(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReminderCard(
                  route: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SleepReminders();
                    }));
                  },
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
