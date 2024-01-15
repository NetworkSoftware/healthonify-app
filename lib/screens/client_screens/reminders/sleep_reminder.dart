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

class SleepReminders extends StatefulWidget {
  const SleepReminders({Key? key}) : super(key: key);

  @override
  State<SleepReminders> createState() => _SleepRemindersState();
}

class _SleepRemindersState extends State<SleepReminders> {
  late String userId;
  bool isLoading = false;

  ReminderSharedPref reminderPreferences = ReminderSharedPref();

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    // getSleepReminders();
    getReminders();
  }

  void getReminders() async {
    await getSleepReminder();
    await getWakeupReminder();
  }

  void saveSleepReminder() {
    reminderPreferences.saveSleepReminder(
      enabled: isSleepTime,
      time: formattedSleepTime!,
    );
  }

  void saveWakeupReminder() {
    reminderPreferences.saveWakeUpReminder(
      enabled: isWakeTime,
      time: formattedWakeTime!,
    );
  }

  Map<String, dynamic> sleeptimeReminder = {};
  Map<String, dynamic> wakeuptimeReminder = {};

  Future<void> getSleepReminder() async {
    sleeptimeReminder = await reminderPreferences.getSleepReminder();

    setState(() {
      formattedSleepTime = sleeptimeReminder['time'];
      isSleepTime = sleeptimeReminder['isEnabled'];

      formatSleepTime();

      getSleepTime();
    });
  }

  Future<void> getWakeupReminder() async {
    wakeuptimeReminder = await reminderPreferences.getWakeUpReminder();

    setState(() {
      formattedWakeTime = wakeuptimeReminder['time'];
      isWakeTime = wakeuptimeReminder['isEnabled'];
      formatWakeupTime();

      getWakeupTime();
    });
  }

  formatSleepTime() {
    var tempTime = DateFormat('HH:mm').parse(sleeptimeReminder['time']);
    sleepingTime = DateFormat('h:mm a').format(tempTime);
  }

  formatWakeupTime() {
    var tempTime = DateFormat('HH:mm').parse(wakeuptimeReminder['time']);
    wakingTime = DateFormat('h:mm a').format(tempTime);
  }

  int? sleepHour;
  int? sleepMinutes;

  void getSleepTime() {
    log(sleeptimeReminder.toString());
    var datetime = DateFormat('HH:mm').parse(formattedSleepTime!);
    var tod = TimeOfDay.fromDateTime(datetime);

    sleepHour = tod.hour;
    sleepMinutes = tod.minute;
  }

  int? wakeupHour;
  int? wakeupMinutes;

  void getWakeupTime() {
    log(wakeuptimeReminder.toString());
    var datetime = DateFormat('HH:mm').parse(formattedWakeTime!);
    var tod = TimeOfDay.fromDateTime(datetime);

    wakeupHour = tod.hour;
    wakeupMinutes = tod.minute;
  }

  String? sleepingTime;
  String? wakingTime;
  String? formattedSleepTime;
  String? formattedWakeTime;

  bool isSleepTime = false;
  bool isWakeTime = false;

  void onSubmit() {
    sleepMap["userId"] = userId;
    sleepMap["sleepTimeReminderEnabled"] = isSleepTime;
    sleepMap["wakeupTimeReminderEnabled"] = isWakeTime;
    if (formattedSleepTime != null) {
      sleepMap["sleepTime"] = formattedSleepTime;
    }
    if (formattedWakeTime != null) {
      sleepMap["wakeupTime"] = formattedWakeTime;
    }
  }

  Map<String, dynamic> sleepMap = {};

  Future postSleepReminders() async {
    try {
      await Provider.of<ReminderProvider>(context, listen: false)
          .postSleepReminder(sleepMap);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to upload sleep reminder');
    }
  }

  void callApi() {
    onSubmit();
    postSleepReminders();
  }

  // List<SleepReminder> sleepReminder = [];

  // Future getSleepReminders() async {
  //   try {
  //     sleepReminder =
  //         await Provider.of<ReminderProvider>(context, listen: false)
  //             .getSleepReminders(userId);

  //     sleepingTime = sleepReminder[0].sleepTime ?? "9:30 PM";
  //     wakingTime = sleepReminder[0].wakeupTime ?? "7:00 AM";

  //     formatReminderTime();
  //     isSleepTime = sleepReminder[0].sleepTimeReminderEnabled ?? false;
  //     isWakeTime = sleepReminder[0].wakeupTimeReminderEnabled ?? false;

  //     log('fetched sleep reminders');
  //   } on HttpException catch (e) {
  //     log(e.toString());
  //     Fluttertoast.showToast(msg: e.message);
  //   } catch (e) {
  //     log("Error getting sleep reminders $e");
  //     Fluttertoast.showToast(msg: "Unable to fetch sleep reminders");
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // formatReminderTime() {
  //   var tempSleep =
  //       DateFormat('hh:mm').parse(sleepReminder[0].sleepTime ?? "9:30 PM");
  //   var tempWake =
  //       DateFormat('hh:mm').parse(sleepReminder[0].wakeupTime ?? "7:00 AM");

  //   sleepingTime = DateFormat('h:mm a').format(tempSleep);
  //   wakingTime = DateFormat('h:mm a').format(tempWake);
  // }
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: const CustomAppBar(appBarTitle: 'Sleep Reminder'),
            body: Column(
              children: [
                const SizedBox(height: 20),
                ListTile(
                  onTap: () {
                    timePicker(true);
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sleep Time',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        sleepingTime ?? "10:00 PM",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: orange,
                            ),
                      ),
                    ],
                  ),
                  trailing: Switch(
                    activeColor: orange,
                    inactiveTrackColor: Colors.grey[600],
                    value: isSleepTime,
                    onChanged: (val) {
                      setState(() {
                        if (val == false) {
                          FirebaseNotif().cancelNotif(sleepTimeId);
                        } else {
                           
                        }
                        isSleepTime = !isSleepTime;
                        callApi();
                        saveSleepReminder();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  onTap: () {
                    timePicker(false);
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wake Time',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        wakingTime ?? "7:30 AM",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: orange,
                            ),
                      ),
                    ],
                  ),
                  trailing: Switch(
                    activeColor: orange,
                    inactiveTrackColor: Colors.grey[600],
                    value: isWakeTime,
                    onChanged: (val) {
                      setState(() {
                        if (val == false) {
                          FirebaseNotif().cancelNotif(wakeupTimeId);
                        } else {
                          FirebaseNotif().scheduledNotification(
                            id: wakeupTimeId,
                            hour: wakeupHour!,
                            minute: wakeupMinutes!,
                            title: "It's time to wake up",
                            desc: "Good Morning! Have an amazing day!",
                          );
                        }
                        isWakeTime = !isWakeTime;
                        callApi();
                        saveWakeupReminder();
                      });
                    },
                  ),
                ),
              ],
            ),
          );
  }

  void timePicker(bool isSleepingTime) {
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

        //! formatting and displaying time

        if (isSleepingTime) {
          formattedSleepTime =
              '${selection.hour.toString().padLeft(2, "0")}:${selection.minute.toString().padLeft(2, "0")}';
          sleepingTime = selection.format(context);
          isSleepTime = true;

          getSleepTime();
          FirebaseNotif().scheduledNotification(
            id: sleepTimeId,
            hour: sleepHour!,
            minute: sleepMinutes!,
            title: "It's time to sleep",
            desc: "ZZZ ... sweet dreams",
          );
          saveSleepReminder();
        } else {
          formattedWakeTime =
              '${selection.hour.toString().padLeft(2, "0")}:${selection.minute.toString().padLeft(2, "0")}';
          wakingTime = selection.format(context);
          isWakeTime = true;

          getWakeupTime();
          FirebaseNotif().scheduledNotification(
            id: wakeupTimeId,
            hour: wakeupHour!,
            minute: wakeupMinutes!,
            title: "It's time to wake up",
            desc: "Good Morning! Have an amazing day!",
          );
          saveWakeupReminder();
        }
        callApi();
      });
    });
  }
}
