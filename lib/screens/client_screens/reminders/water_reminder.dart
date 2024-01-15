import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/reminder_ids.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/fiirebase_notifications.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/providers/reminders/reminder_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/buttons/custom_buttons.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:healthonify_mobile/widgets/other/num_picker.dart';
import 'package:provider/provider.dart';

enum Radios { reminderInterval, reminderFrequency }

class WaterReminders extends StatefulWidget {
  const WaterReminders({Key? key}) : super(key: key);

  @override
  State<WaterReminders> createState() => _WaterRemindersState();
}

class _WaterRemindersState extends State<WaterReminders> {
  late String userId;

  // bool isLoading = false;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    // getWaterReminder();
    getReminder();

    interval ?? 1;
    frequency ?? 3;
  }

  void getReminder() async {
    await getWaterPreferences();
  }

  bool trackReminder = false;

  Object? radio1;
  late bool radioChoice;

  Radios firstRadio = Radios.reminderInterval;
  Radios secondRadio = Radios.reminderFrequency;

  int? interval;
  int? frequency;

  String? formattedTime;
  String? fromTime;
  String? toTime;
  String? formattedFromTime;
  String? formattedToTime;

  bool isInterval = true;

  ReminderSharedPref preferences = ReminderSharedPref();

  Map<String, dynamic> waterPreferences = {};

  Future<void> saveWaterTracker() async {
    preferences.saveWaterReminderTracker(
      enabled: trackReminder,
    );
    log('water tracker set');
    if (trackReminder != true) {
      FirebaseNotif().cancelNotif(waterReminderId);
    } else {
      enableNotifications();
    }
  }

  Future<void> saveFromTime() async {
    preferences.saveWaterReminderFromTime(
      time: formattedFromTime!,
    );
    log('from time preferences set: $formattedFromTime');
  }

  Future<void> saveToTime() async {
    preferences.saveWaterReminderToTime(
      time: formattedToTime!,
    );
    log('to time preferences set: $formattedToTime');
  }

  Future<void> saveInterval() async {
    preferences.saveWaterReminderInterval(
      interval: interval!,
      isSelected: isInterval ? true : false,
    );
  }

  Future<void> saveFrequency() async {
    preferences.saveWaterReminderFrequency(
      frequency: frequency!,
      isSelected: isInterval ? false : true,
    );
  }

  DateTime? fromDateTime;
  DateTime? toDateTime;
  Future<void> getWaterPreferences() async {
    waterPreferences = await preferences.getWaterReminderPreferences();

    setState(() {
      trackReminder = waterPreferences['isEnabled'];
      formattedFromTime = waterPreferences['fromTime'];
      formattedToTime = waterPreferences['toTime'];
      interval = waterPreferences['interval'];
      frequency = waterPreferences['frequency'];

      radioChoice = waterPreferences['isFirstRadioSelected'];
      radio1 = radioChoice ? Radios.reminderInterval : Radios.reminderFrequency;

      formatWaterReminderTimes();
      getWaterReminderTimes();

      Duration? fromToDifference;
      fromDateTime = DateFormat('hh:mm').parse(formattedFromTime!);
      toDateTime = DateFormat('hh:mm').parse(formattedToTime!);

      fromToDifference = toDateTime!.difference(fromDateTime!);

      Duration absoluteDuration;
      log('fromToDifference value $fromToDifference');

      if (fromToDifference.isNegative) {
        toDateTime = toDateTime!.add(const Duration(days: 1));
        fromToDifference = toDateTime!.difference(fromDateTime!);
      }
      absoluteDuration = fromToDifference.abs();
      durationInMinutes = absoluteDuration.inMinutes;

      log('from date time: $fromDateTime');
      log('to date time: $toDateTime');

      log('time duration: $absoluteDuration');
      log('duration in minutes: $durationInMinutes');
    });

    getNotificationList();

    log('water reminder fetched: $waterPreferences');
  }

  void getNotificationList() {
    var startTime;

    if (formattedTime1 == null) {
      startTime = fromDateTime;
    } else {
      startTime = formattedTime1;
    }

    if (radio1 == Radios.reminderInterval) {
      var intervalMinutes = interval! * 60;
      intervalNos = durationInMinutes! / intervalMinutes;
      numberOfIntervals = intervalNos!.truncate();

      log('number of intervals: $numberOfIntervals');

      for (int i = 0; i < numberOfIntervals!; i++) {
        notificationTimes.add(startTime);
        startTime = startTime!.add(Duration(minutes: intervalMinutes));
        log('start time $i is $startTime');
      }
      notificationTimes.add(startTime);
      log('notification times: $notificationTimes');
    } else {
      int intervalFrequency = frequency!;
      double durationIntervals = durationInMinutes! / intervalFrequency;
      int freq = durationIntervals.truncate();
      log('interval frequency: $intervalFrequency and duration interval is: $freq');

      for (var i = 0; i < intervalFrequency; i++) {
        startTime = startTime!.add(Duration(minutes: freq));
        log('start time $i is $startTime');
        notificationTimes.add(startTime);
      }
      log('notification times: $notificationTimes');
    }
  }

  formatWaterReminderTimes() {
    var tempTime1 = DateFormat('HH:mm').parse(waterPreferences['fromTime']);
    var tempTime2 = DateFormat('HH:mm').parse(waterPreferences['toTime']);

    fromTime = DateFormat('h:mm a').format(tempTime1);
    toTime = DateFormat('h:mm a').format(tempTime2);
  }

  int? fromHour;
  int? fromMinutes;
  int? toHour;
  int? toMinutes;
  void getWaterReminderTimes() {
    var datetime1 = DateFormat('HH:mm').parse(formattedFromTime!);
    var tod1 = TimeOfDay.fromDateTime(datetime1);

    var datetime2 = DateFormat('HH:mm').parse(formattedToTime!);
    var tod2 = TimeOfDay.fromDateTime(datetime2);

    fromHour = tod1.hour;
    fromMinutes = tod1.minute;

    toHour = tod2.hour;
    toMinutes = tod2.minute;
  }

  List notificationTimes = [];

  void cancelNotifications() {
    if (trackReminder != true) {
      FirebaseNotif().cancelNotif(waterReminderId);
    }
  }

  Map<String, dynamic> waterMap = {};

  void onSubmit() {
    if (trackReminder != false) {
      waterMap["reminderFromTime"] = formattedFromTime;
      waterMap["reminderToTime"] = formattedToTime;

      if (isInterval == true) {
        waterMap["hourlyReminder"] = interval ?? 1;
        waterMap["hourlyReminderEnabled"] = true;
        waterMap["reminderTimesEnabled"] = false;
      } else {
        waterMap["reminderTimes"] = frequency ?? 3;
        waterMap["reminderTimesEnabled"] = true;
        waterMap["hourlyReminderEnabled"] = false;
      }
    }
    if (trackReminder == false) {
      waterMap = {};
    }
    waterMap["userId"] = userId;
    waterMap["reminderEnabled"] = trackReminder;

    log(waterMap.toString());
  }

  void callApi() {
    onSubmit();
    postWaterReminder();
  }

  Future postWaterReminder() async {
    try {
      await Provider.of<ReminderProvider>(context, listen: false)
          .postWaterReminder(waterMap);
      // Fluttertoast.showToast(msg: 'Water reminders set successfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to set water reminder');
    }
  }

  void enableNotifications() {
    if (trackReminder == true) {
      if (notificationTimes.isNotEmpty) {
        for (var i = 0; i < notificationTimes.length; i++) {
          var tod = TimeOfDay.fromDateTime(notificationTimes[i]);
          var hours = tod.hour;
          var minutes = tod.minute;

          log('formatted date time: $hours:$minutes');

          FirebaseNotif().scheduledNotification(
            id: waterReminderId,
            hour: hours,
            minute: minutes,
            title: "Time to drink water",
            desc: "Stay hydrated for the day",
          );
        }
      }
    } else {
      FirebaseNotif().cancelNotif(waterReminderId);
    }
  }
  // List<WaterReminder> waterReminder = [];

  // Future getWaterReminder() async {
  //   try {
  //     waterReminder =
  //         await Provider.of<ReminderProvider>(context, listen: false)
  //             .getWaterReminders(userId);

  //     trackReminder = waterReminder[0].reminderEnabled ?? false;
  //     fromTime = waterReminder[0].reminderFromTime ?? '9:30 AM';
  //     toTime = waterReminder[0].reminderToTime ?? '9:30 PM';
  //     interval = waterReminder[0].hourlyReminder ?? 1;
  //     frequency = waterReminder[0].reminderTimes ?? 3;

  //     waterReminder[0].hourlyReminderEnabled == true
  //         ? radio1 = Radios.reminderInterval
  //         : radio1 = Radios.reminderFrequency;

  //     log('fetched water reminders');
  //   } on HttpException catch (e) {
  //     log(e.toString());
  //     Fluttertoast.showToast(msg: e.message);
  //   } catch (e) {
  //     log("Error getting water reminders $e");
  //     Fluttertoast.showToast(msg: "Unable to fetch water reminders");
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // int defaultInterval = interval ?? 1;
    // int defaultFrequency = frequency ?? 3;

    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Water Reminder'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            tileColor: Theme.of(context).canvasColor,
            title: Text(
              'Drink Water Reminder',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            trailing: Switch(
              activeColor: orange,
              inactiveTrackColor: Colors.grey[600],
              value: trackReminder,
              onChanged: (val) {
                setState(() {
                  trackReminder = !trackReminder;
                  saveWaterTracker();
                  callApi();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Text(
              'Get reminded to drink water',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Water reminder help you meet your hydration goal of a minimum 9 glasses per day.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: ListTile(
                        onTap: () {
                          timePicker(true);
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'From',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              fromTime ?? "9:00 AM",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: orange,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: ListTile(
                        onTap: () {
                          timePicker(false);
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'To',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 20),
                            Text(
                              toTime ?? "9:00 PM",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: orange,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            onTap: () {
              bottomNumberPicker(true);
            },
            leading: Radio(
              value: firstRadio,
              groupValue: radio1,
              onChanged: (val) {
                setState(() {
                  radio1 = val;
                  radio1 == Radios.reminderInterval
                      ? isInterval = true
                      : isInterval = false;
                  log(radio1.toString());

                  if (isInterval == true) {
                    saveInterval();
                  } else {
                    saveFrequency();
                  }
                  callApi();
                });
              },
            ),
            title: Text(
              'Remind me every',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Text(
              "$interval hours",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: orange,
                  ),
            ),
          ),
          ListTile(
            onTap: () {
              bottomNumberPicker(false);
            },
            leading: Radio(
              fillColor: MaterialStateProperty.all<Color>(orange),
              value: secondRadio,
              groupValue: radio1,
              onChanged: (val) {
                setState(() {
                  radio1 = val;
                  radio1 == Radios.reminderFrequency
                      ? isInterval = false
                      : isInterval = true;
                  log(val.toString());

                  if (isInterval == true) {
                    saveFrequency();
                  }
                  saveInterval();
                  callApi();
                });
              },
            ),
            title: Text(
              'Remind me',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: Text(
              "$frequency times",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: orange,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  double? intervalNos;
  int? numberOfIntervals;
  int? durationInMinutes;
  void bottomNumberPicker(bool isInterval) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.42,
              child: isInterval
                  ? NumPicker(
                      minimumValue: 1,
                      maximumValue: 24,
                      initVal: interval ?? 1,
                      getNumber: (value) {
                        setState(() {
                          interval = value;
                          if (trackReminder == false) {
                            trackReminder = !trackReminder;
                          }
                        });
                      },
                    )
                  : NumPicker(
                      minimumValue: 1,
                      maximumValue: 20,
                      initVal: frequency ?? 3,
                      getNumber: (value) {
                        setState(() {
                          frequency = value;
                        });
                      },
                    ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientButton(
                  title: 'Save',
                  func: () {
                    notificationTimes = [];
                    DateTime? startTime;

                    if (formattedTime1 == null) {
                      startTime = fromDateTime;
                    } else {
                      startTime = formattedTime1;
                    }

                    if (isInterval) {
                      saveInterval();
                      setState(() {
                        radio1 = Radios.reminderInterval;
                      });
                    } else {
                      saveFrequency();
                      setState(() {
                        radio1 = Radios.reminderFrequency;
                      });
                    }

                    getNotificationList();
                    enableNotifications();

                    Navigator.pop(context);
                    callApi();
                  },
                  gradient: orangeGradient,
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  DateTime? formattedTime1;
  DateTime? formattedTime2;

  void timePicker(bool isFromTime) {
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
      notificationTimes = [];
      setState(() {
        trackReminder = true;
        var selection = value;
        //! converting to 24hr format.
        formattedTime =
            '${selection.hour.toString().padLeft(2, "0")}:${selection.minute.toString().padLeft(2, "0")}';
        log(formattedTime!);
        //!displaying time in 12hr format on the ui.
        DateTime? fromDateTime;
        DateTime? toDateTime;

        if (isFromTime) {
          fromTime = selection.format(context);
          fromDateTime = DateFormat('hh:mm').parse(formattedTime!);
          formattedTime1 = fromDateTime;
          formattedFromTime = formattedTime;
          saveFromTime();
        } else {
          toTime = selection.format(context);
          toDateTime = DateFormat('hh:mm').parse(formattedTime!);
          formattedTime2 = toDateTime;
          formattedToTime = formattedTime;
          saveToTime();
        }

        Duration? fromToDifference;
        if (!isFromTime) {
          fromToDifference = formattedTime2!.difference(formattedTime1!);
        }

        Duration absoluteDuration;
        if (fromToDifference != null) {
          log('fromToDifference value $fromToDifference');

          if (fromToDifference.isNegative) {
            formattedTime2 = formattedTime2!.add(const Duration(days: 1));
            fromToDifference = formattedTime2!.difference(formattedTime1!);
          }
          absoluteDuration = fromToDifference.abs();
          durationInMinutes = absoluteDuration.inMinutes;

          log('from date time: $formattedTime1');
          log('to date time: $formattedTime2');

          log('time duration: $absoluteDuration');
          log('duration in minutes: $durationInMinutes');
        }
      });
      getNotificationList();
      enableNotifications();

      callApi();
    });
  }
}
