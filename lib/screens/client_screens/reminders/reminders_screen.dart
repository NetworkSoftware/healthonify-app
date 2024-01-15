import 'package:flutter/material.dart';
import 'package:healthonify_mobile/screens/client_screens/reminders/meal_reminders.dart';
import 'package:healthonify_mobile/screens/client_screens/reminders/pill_reminder.dart';
import 'package:healthonify_mobile/screens/client_screens/reminders/sleep_reminder.dart';
import 'package:healthonify_mobile/screens/client_screens/reminders/steps_reminder.dart';
import 'package:healthonify_mobile/screens/client_screens/reminders/water_reminder.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List reminderItems = [
      {
        'title': 'Meal Reminders',
        'icon': 'assets/icons/meal_reminder.png',
        'onTap': () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const MealReminders(hideAppbar: false);
          }));
        },
      },
      {
        'title': 'Water Reminder',
        'icon': 'assets/icons/water.png',
        'onTap': () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const WaterReminders();
          }));
        },
      },
      {
        'title': 'Sleep Reminder',
        'icon': 'assets/icons/sleep_reminder.png',
        'onTap': () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const SleepReminders();
          }));
        },
      },
      {
        'title': 'Steps Reminder',
        'icon': 'assets/icons/steps.png',
        'onTap': () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const StepsReminders();
          }));
        },
      },
      {
        'title': 'Medicine Reminder',
        'icon': 'assets/icons/buy_meds.png',
        'onTap': () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const PillReminderScreen();
          }));
        },
      },
    ];
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Reminders'),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: reminderItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: reminderItems[index]["onTap"],
                leading: Image.asset(
                  reminderItems[index]["icon"],
                  height: 40,
                ),
                title: Text(
                  reminderItems[index]["title"],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Divider(color: Colors.grey);
            },
          ),
        ],
      ),
    );
  }
}
