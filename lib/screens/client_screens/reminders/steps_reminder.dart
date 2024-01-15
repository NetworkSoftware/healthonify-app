import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/reminder_ids.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/fiirebase_notifications.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/providers/reminders/reminder_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StepsReminders extends StatefulWidget {
  const StepsReminders({Key? key}) : super(key: key);

  @override
  State<StepsReminders> createState() => _StepsRemindersState();
}

class _StepsRemindersState extends State<StepsReminders> {
  bool isLoading = true;
  bool trackReminder = false;
  late String userId;

  ReminderSharedPref reminderPreferences = ReminderSharedPref();

  Map<String, dynamic> reminderMap = {};

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    getReminder();
  }

  void saveReminder() async {
    reminderPreferences.saveStepsReminder(
      enabled: trackReminder,
      time: formattedTime!,
    );

    log('reminder saved to shared pref');
  }

  void getReminder() async {
    reminderMap = await reminderPreferences.getStepsReminder();

    setState(() {
      trackReminder = reminderMap['isEnabled'];
      formattedTime = reminderMap['time'];

      formatReminderTo12Hrs();
    });

    getReminderTime();
  }

  int? reminderHour;
  int? reminderMinutes;

  getReminderTime() {
    log('reminder formatted time: $formattedTime');
    var datetime = DateFormat('HH:mm').parse(formattedTime!);
    var tod = TimeOfDay.fromDateTime(datetime);

    reminderHour = tod.hour;
    reminderMinutes = tod.minute;
  }

  formatReminderTo12Hrs() {
    var tempTime = DateFormat('HH:mm').parse(reminderMap['time']);
    reminderTime = DateFormat('h:mm a').format(tempTime);
  }

  String reminderTime = '9:30 am';
  String? formattedTime;

  Map<String, dynamic> stepsMap = {};

  Future postStepsReminder() async {
    try {
      await Provider.of<ReminderProvider>(context, listen: false)
          .postStepsReminder(stepsMap);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to set steps reminder');
    }
  }

  void onSubmit() {
    stepsMap["userId"] = userId;
    stepsMap["walkReminderEnabled"] = trackReminder;
    stepsMap["remindMeEnabled"] = trackReminder;
    if (formattedTime != null) {
      stepsMap["remindMeAt"] = formattedTime;
    }

    log(stepsMap.toString());
  }

  // List<StepsReminder> stepsReminder = [];

  // Future getStepsReminder() async {
  //   try {
  //     stepsReminder =
  //         await Provider.of<ReminderProvider>(context, listen: false)
  //             .getStepsReminders(userId);

  //     trackReminder = stepsReminder[0].walkReminderEnabled ?? false;
  //     reminderTime = stepsReminder[0].remindMeAt ?? "09:30";

  //     formatReminderTo12Hrs();

  //     log('fetched steps reminder');
  //   } on HttpException catch (e) {
  //     log(e.toString());
  //     Fluttertoast.showToast(msg: e.message);
  //   } catch (e) {
  //     log("Error getting steps reminder $e");
  //     Fluttertoast.showToast(msg: "Unable to fetch steps reminder");
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  void callApi() {
    onSubmit();
    postStepsReminder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Steps Reminder'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            tileColor: Theme.of(context).canvasColor,
            title: Text(
              'Walk Reminder',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            trailing: Switch(
              activeColor: orange,
              inactiveTrackColor: Colors.grey[600],
              value: trackReminder,
              onChanged: (val) {
                setState(() {
                  if (val == false) {
                    FirebaseNotif().cancelNotif(stepsReminderId);
                  } else {
                    FirebaseNotif().scheduledNotification(
                      id: stepsReminderId,
                      hour: reminderHour!,
                      minute: reminderMinutes!,
                      title: "Time to walk",
                      desc: "Complete your target steps",
                    );
                  }
                  trackReminder = !trackReminder;
                  callApi();
                  saveReminder();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Text(
              'Get reminded to walk',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Walk reminders help you increase your daily count. They help you burn calories even on the busiest of days.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            onTap: () {
              timePicker(true);
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Remind me once at',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            trailing: Text(
              reminderTime,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: orange,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void timePicker(bool isSleepTime) {
    showTimePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: customTimePickerTheme,
          child: child!,
        );
      },
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        var selection = value;
        //! converting to 24hr format.
        formattedTime =
            '${selection.hour.toString().padLeft(2, "0")}:${selection.minute.toString().padLeft(2, "0")}';
        log(formattedTime!);
        //!displaying time in 12hr format on the ui.
        reminderTime = selection.format(context);

        trackReminder = true;
        getReminderTime();
        FirebaseNotif().scheduledNotification(
          id: stepsReminderId,
          hour: reminderHour!,
          minute: reminderMinutes!,
          title: "Time to walk",
          desc: "Complete your target steps",
        );
        callApi();
        saveReminder();
      });
    });
  }
}
