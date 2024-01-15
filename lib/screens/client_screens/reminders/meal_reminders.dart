import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/client/reminders/reminder_options.dart';
import 'package:healthonify_mobile/constants/reminder_ids.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/fiirebase_notifications.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/providers/reminders/reminder_provider.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appbar.dart';
import 'package:provider/provider.dart';

enum RadioButtons { dayReminder, radio2Day }

class MealReminders extends StatefulWidget {
  final bool hideAppbar;
  const MealReminders({required this.hideAppbar, Key? key}) : super(key: key);

  @override
  State<MealReminders> createState() => _MealRemindersState();
}

class _MealRemindersState extends State<MealReminders> {
  late String userId;

  ReminderSharedPref reminderPreferences = ReminderSharedPref();

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserData>(context, listen: false).userData.id!;
    // getMealReminders();
    getAllMealPreferences();
  }

  void getAllMealPreferences() async {
    await getMealTracker();
    await getBreakfast();
    await getMorningSnack();
    await getLunch();
    await getEveningSnack();
    await getDinner();
    await getDailyReminder();
  }

  Map<String, dynamic> breakfastMap = {};
  Map<String, dynamic> morningSnackMap = {};
  Map<String, dynamic> lunchMap = {};
  Map<String, dynamic> eveningSnackMap = {};
  Map<String, dynamic> dinnerMap = {};
  Map<String, dynamic> dailyMap = {};

  Future<void> saveMealTracker() async {
    reminderPreferences.saveMealReminderTracker(
      enabled: trackReminder,
    );
    log('meal tracker set');
  }

  Future<void> getMealTracker() async {
    trackReminder = await reminderPreferences.getMealReminderTracker();
    log('meal tracker fetched: $trackReminder');
  }

  void enableNotifications() {
    if (breakfastSwitch == true) {
      FirebaseNotif().scheduledNotification(
        id: breakfastId,
        hour: breakfastHour!,
        minute: breakfastMinutes!,
        title: "It's time for breakfast",
        desc: "It's time for breakfast",
      );
    }
    if (morningSnackSwitch == true) {
      FirebaseNotif().scheduledNotification(
        id: morningSnackId,
        hour: morningSnackHour!,
        minute: morningSnackMinutes!,
        title: "It's time for your first snack",
        desc: "It's time for your first snack",
      );
    }
    if (lunchSwitch == true) {
      FirebaseNotif().scheduledNotification(
        id: lunchId,
        hour: lunchHour!,
        minute: lunchMinutes!,
        title: "It's time for lunch",
        desc: "It's time for lunch",
      );
    }
    if (eveningSnackSwitch == true) {
      FirebaseNotif().scheduledNotification(
        id: eveningSnackId,
        hour: eveningSnackHour!,
        minute: eveningSnackMinutes!,
        title: "It's time for your evening snack",
        desc: "It's time for your evening snack",
      );
    }
    if (dinnerSwitch == true) {
      FirebaseNotif().scheduledNotification(
        id: dinnerId,
        hour: dinnerHour!,
        minute: dinnerMinutes!,
        title: "It's time for dinner",
        desc: "It's time for dinner",
      );
    }
    if (isDailyReminderEnabled == true) {
      FirebaseNotif().scheduledNotification(
        id: dailyId,
        hour: dailyHour!,
        minute: dailyMinutes!,
      );
    }
  }

  void cancelNotifications() {
    if (breakfastSwitch == true) {
      FirebaseNotif().cancelNotif(breakfastId);
    }
    if (morningSnackSwitch == true) {
      FirebaseNotif().cancelNotif(morningSnackId);
    }
    if (lunchSwitch == true) {
      FirebaseNotif().cancelNotif(lunchId);
    }
    if (eveningSnackSwitch == true) {
      FirebaseNotif().cancelNotif(eveningSnackId);
    }
    if (dinnerSwitch == true) {
      FirebaseNotif().cancelNotif(dinnerId);
    }
    if (isDailyReminderEnabled == true) {
      FirebaseNotif().cancelNotif(dailyId);
    }
  }

  Future<void> saveBreakfastReminder() async {
    reminderPreferences.saveBreakfastPreferences(
      enabled: breakfastSwitch,
      time: formattedBreakfastTime!,
    );
    log('breakfast preferences set');
  }

  Future<void> saveMorningSnackReminder() async {
    reminderPreferences.saveMorningSnackPreferences(
      enabled: morningSnackSwitch,
      time: formattedMorningSnackTime!,
    );
    log('morning snack preferences set');
  }

  Future<void> saveLunchReminder() async {
    reminderPreferences.saveLunchPreferences(
      enabled: lunchSwitch,
      time: formattedLunchTime!,
    );
    log('lunch preferences set');
  }

  Future<void> saveEveningSnackReminder() async {
    reminderPreferences.saveEveningSnackPreferences(
      enabled: eveningSnackSwitch,
      time: formattedEveningSnackTime!,
    );
    log('evening snack preferences set');
  }

  Future<void> saveDinnerReminder() async {
    reminderPreferences.saveDinnerPreferences(
      enabled: dinnerSwitch,
      time: formattedDinnerTime!,
    );
    log('dinner preferences set');
  }

  Future<void> saveRemindMeAt() async {
    reminderPreferences.saveMealReminderTime(
      enabled: isDailyReminderEnabled,
      time: formattedEveryReminder!,
    );
    log('daily reminder set preferences set');
  }

  Future<void> getBreakfast() async {
    breakfastMap = await reminderPreferences.getBreakfastPreferences();

    setState(() {
      formattedBreakfastTime = breakfastMap['time'];
      breakfastSwitch = breakfastMap['isEnabled'];

      formatBreakFastTime();
      getBreakfastTime();
    });
    log('breakfast fetched: $breakfastMap');
  }

  int? breakfastHour;
  int? breakfastMinutes;
  formatBreakFastTime() {
    var tempTime = DateFormat('HH:mm').parse(breakfastMap['time']);
    breakfastTime = DateFormat('h:mm a').format(tempTime);
  }

  void getBreakfastTime() {
    var datetime = DateFormat('HH:mm').parse(formattedBreakfastTime!);
    var tod = TimeOfDay.fromDateTime(datetime);

    breakfastHour = tod.hour;
    breakfastMinutes = tod.minute;
  }

  Future<void> getMorningSnack() async {
    morningSnackMap = await reminderPreferences.getMorningSnackPreferences();

    setState(() {
      formattedMorningSnackTime = morningSnackMap['time'];
      morningSnackSwitch = morningSnackMap['isEnabled'];

      formatMorningSnackTime();
      getMorningSnackTime();
    });
    log('morning snacks fetched: $morningSnackMap');
  }

  int? morningSnackHour;
  int? morningSnackMinutes;
  formatMorningSnackTime() {
    var tempTime = DateFormat('HH:mm').parse(morningSnackMap['time']);
    morningSnack = DateFormat('h:mm a').format(tempTime);
  }

  void getMorningSnackTime() {
    var datetime = DateFormat('HH:mm').parse(formattedMorningSnackTime!);
    var tod = TimeOfDay.fromDateTime(datetime);

    morningSnackHour = tod.hour;
    morningSnackMinutes = tod.minute;
  }

  Future<void> getLunch() async {
    lunchMap = await reminderPreferences.getLunchPreferences();

    setState(() {
      formattedLunchTime = lunchMap['time'];
      lunchSwitch = lunchMap['isEnabled'];

      formatLunchTime();
      getLunchTime();
    });
    log('lunch fetched: $lunchMap');
  }

  int? lunchHour;
  int? lunchMinutes;
  formatLunchTime() {
    var tempTime = DateFormat('HH:mm').parse(lunchMap['time']);
    lunch = DateFormat('h:mm a').format(tempTime);
  }

  void getLunchTime() {
    var datetime = DateFormat('HH:mm').parse(formattedLunchTime!);
    var tod = TimeOfDay.fromDateTime(datetime);

    lunchHour = tod.hour;
    lunchMinutes = tod.minute;
  }

  Future<void> getEveningSnack() async {
    eveningSnackMap = await reminderPreferences.getEveningSnackPreferences();

    setState(() {
      formattedEveningSnackTime = eveningSnackMap['time'];
      eveningSnackSwitch = eveningSnackMap['isEnabled'];

      formatEveningSnackTime();
      getEveningSnackTime();
    });
    log('evening snacks fetched: $eveningSnackMap');
  }

  int? eveningSnackHour;
  int? eveningSnackMinutes;
  formatEveningSnackTime() {
    var tempTime = DateFormat('HH:mm').parse(eveningSnackMap['time']);
    eveningSnack = DateFormat('h:mm a').format(tempTime);
  }

  void getEveningSnackTime() {
    var datetime = DateFormat('HH:mm').parse(formattedEveningSnackTime!);
    var tod = TimeOfDay.fromDateTime(datetime);

    eveningSnackHour = tod.hour;
    eveningSnackMinutes = tod.minute;
  }

  Future<void> getDinner() async {
    dinnerMap = await reminderPreferences.getDinnerPreferences();

    setState(() {
      formattedDinnerTime = dinnerMap['time'];
      dinnerSwitch = dinnerMap['isEnabled'];

      formatDinnerTime();
      getDinnerTime();
    });
    log('dinner fetched: $dinnerMap');
  }

  int? dinnerHour;
  int? dinnerMinutes;
  formatDinnerTime() {
    var tempTime = DateFormat('HH:mm').parse(dinnerMap['time']);
    dinner = DateFormat('h:mm a').format(tempTime);
  }

  void getDinnerTime() {
    var datetime = DateFormat('HH:mm').parse(formattedDinnerTime!);
    var tod = TimeOfDay.fromDateTime(datetime);

    dinnerHour = tod.hour;
    dinnerMinutes = tod.minute;
  }

  Future<void> getDailyReminder() async {
    dailyMap = await reminderPreferences.getMealReminderTime();

    setState(() {
      formattedEveryReminder = dailyMap['time'];
      isDailyReminderEnabled = dailyMap['isEnabled'];

      formatDailyTime();
      getDailyTime();
    });
    log('daily reminder time fetched: $dailyMap');
  }

  int? dailyHour;
  int? dailyMinutes;
  formatDailyTime() {
    var tempTime = DateFormat('HH:mm').parse(dailyMap['time']);
    radio1Time = DateFormat('h:mm a').format(tempTime);
  }

  void getDailyTime() {
    var datetime = DateFormat('HH:mm').parse(formattedEveryReminder!);
    var tod = TimeOfDay.fromDateTime(datetime);

    dailyHour = tod.hour;
    dailyMinutes = tod.minute;
  }

  bool trackReminder = false;
  String? formattedBreakfastTime;
  String? formattedLunchTime;
  String? formattedDinnerTime;
  String? formattedMorningSnackTime;
  String? formattedEveningSnackTime;

  String? breakfastTime;
  String? morningSnack;
  String? lunch;
  String? eveningSnack;
  String? dinner;

  bool breakfastSwitch = false;
  bool morningSnackSwitch = false;
  bool lunchSwitch = false;
  bool eveningSnackSwitch = false;
  bool dinnerSwitch = false;

  bool isDailyReminderEnabled = true;
  // bool isWeeklyReminderEnabled = false;

  String? formattedEveryReminder;
  String? formattedWeeklyReminder;

  String? radioTime;
  Object? radio1 = RadioButtons.dayReminder;
  String? radio1Time;
  // String? radio2Day;

  Map<String, dynamic> mealMap = {};

  Future postMealReminders() async {
    try {
      await Provider.of<ReminderProvider>(context, listen: false)
          .postMealReminder(mealMap);
      // Fluttertoast.showToast(msg: 'Meal reminders uploaded successfully');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: 'Unable to upload meal reminder');
    }
  }

  void callApi() {
    onSubmit();
    postMealReminders();
    // getMealReminders();
  }

  void onSubmit() {
    if (formattedBreakfastTime != null) {
      mealMap["breakfast"] = formattedBreakfastTime;
    }
    if (formattedLunchTime != null) {
      mealMap["lunch"] = formattedLunchTime;
    }
    if (formattedDinnerTime != null) {
      mealMap["dinner"] = formattedDinnerTime;
    }
    if (formattedMorningSnackTime != null) {
      mealMap["morningSnack"] = formattedMorningSnackTime;
    }
    if (formattedEveningSnackTime != null) {
      mealMap["eveningSnack"] = formattedEveningSnackTime;
    }
    if (trackReminder != false) {
      if (isDailyReminderEnabled != false) {
        mealMap["remindmeEverydayAt"] = formattedEveryReminder ?? radio1Time;
        mealMap["dailyreminderEnabled"] = isDailyReminderEnabled;
      }
      // mealMap["remindmeEverydayAt"] = formattedEveryReminder ?? radio1Time;
      // mealMap["remindmeEveryweekAt"] = formattedWeeklyReminder ?? radio2Day;
      // mealMap["dailyreminderEnabled"] = isDailyReminderEnabled;
      // mealMap["weeklyreminderEnabled"] = isWeeklyReminderEnabled;
    }
    if (trackReminder == false) {
      mealMap = {};
    }
    mealMap["userId"] = userId;
    mealMap["reminderEnabled"] = trackReminder;

    log(mealMap.toString());
  }

  bool isLoading = false;
  // List<MealReminder> mealReminderData = [];

  // Future getMealReminders() async {
  //   try {
  //     mealReminderData =
  //         await Provider.of<ReminderProvider>(context, listen: false)
  //             .getMealReminders(userId);

  //     meals[0]["time"] = mealReminderData[0].breakfast ?? "09:00";
  //     meals[1]["time"] = mealReminderData[0].morningSnack ?? "10:30";
  //     meals[2]["time"] = mealReminderData[0].lunch ?? "13:00";
  //     meals[3]["time"] = mealReminderData[0].eveningSnack ?? "16:30";
  //     meals[4]["time"] = mealReminderData[0].dinner ?? "21:00";

  //     formatTo12Hrs(0);
  //     formatTo12Hrs(1);
  //     formatTo12Hrs(2);
  //     formatTo12Hrs(3);
  //     formatTo12Hrs(4);

  //     trackReminder = mealReminderData[0].reminderEnabled ?? false;
  //     radio1Time = mealReminderData[0].remindmeEverydayAt ?? "09:30";

  //     formatRadioTo12Hrs();

  //     radio2Day = mealReminderData[0].remindmeEveryweekAt;

  //     isDailyReminderEnabled =
  //         mealReminderData[0].dailyreminderEnabled ?? false;
  //     isWeeklyReminderEnabled =
  //         mealReminderData[0].weeklyreminderEnabled ?? false;

  //     if (trackReminder == false) {
  //       breakfastSwitch = false;
  //       morningSnackSwitch = false;
  //       lunchSwitch = false;
  //       eveningSnackSwitch = false;
  //       dinnerSwitch = false;
  //     } else {
  //       breakfastSwitch = mealReminderData[0].breakfast == null ? false : true;
  //       morningSnackSwitch =
  //           mealReminderData[0].morningSnack == null ? false : true;
  //       lunchSwitch = mealReminderData[0].lunch == null ? false : true;
  //       eveningSnackSwitch =
  //           mealReminderData[0].eveningSnack == null ? false : true;
  //       dinnerSwitch = mealReminderData[0].dinner == null ? false : true;
  //     }

  //     log('fetched meal reminders');
  //   } on HttpException catch (e) {
  //     log(e.toString());
  //     Fluttertoast.showToast(msg: e.message);
  //   } catch (e) {
  //     log("Error getting meal reminders $e");
  //     Fluttertoast.showToast(msg: "Unable to fetch meal reminders");
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // formatRadioTo12Hrs() {
  //   var tempTime;
  //   tempTime = DateFormat('hh:mm').parse(radio1Time!);
  //   radioTime = DateFormat('h:mm a').format(tempTime);
  // }

  // formatTo12Hrs(int index) {
  //   var tempTime;
  //   var fTime;

  //   if (meals[index]["time"] != null) {
  //     tempTime = DateFormat('hh:mm').parse(meals[index]["time"]);
  //     fTime = DateFormat('h:mm a').format(tempTime);
  //     if (index == 0) {
  //       breakfastTime = fTime;
  //     }
  //     if (index == 1) {
  //       morningSnack = fTime;
  //     }
  //     if (index == 2) {
  //       lunch = fTime;
  //     }
  //     if (index == 3) {
  //       eveningSnack = fTime;
  //     }
  //     if (index == 4) {
  //       dinner = fTime;
  //     }
  //   } else {
  //     return;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: widget.hideAppbar
                ? null
                : const CustomAppBar(appBarTitle: 'Meal Reminders'),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    tileColor: Theme.of(context).canvasColor,
                    title: Text(
                      'Track Meal Reminder',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    trailing: Switch(
                      activeColor: orange,
                      inactiveTrackColor: Colors.grey[600],
                      value: trackReminder,
                      onChanged: (val) {
                        setState(() {
                          trackReminder = !trackReminder;
                          saveMealTracker();
                          if (trackReminder == false) {
                            cancelNotifications();
                          } else {
                            enableNotifications();
                          }
                        });
                        callApi();
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Text(
                      'Get reminded to track your meals',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Food tracking reminders work best when set for 30 mins post meal times. Get into the habit of having 5 or more meals daily.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Text(
                      'Meals',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  //! Breakfast //
                  ListTile(
                    onTap: () {
                      timePicker(0, false, false);
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meals[0]["meal"],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          breakfastTime ?? "Tap to choose reminder time",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: orange,
                                  ),
                        ),
                      ],
                    ),
                    trailing: Switch(
                      activeColor: orange,
                      inactiveTrackColor: Colors.grey[600],
                      value: breakfastSwitch,
                      onChanged: (val) {
                        setState(() {
                          if (val == false) {
                            FirebaseNotif().cancelNotif(breakfastId);
                          } else {
                            FirebaseNotif().scheduledNotification(
                              id: breakfastId,
                              hour: breakfastHour!,
                              minute: breakfastMinutes!,
                            );
                          }
                          breakfastSwitch = !breakfastSwitch;
                        });
                        callApi();
                        saveBreakfastReminder();
                      },
                    ),
                  ),
                  //! Morning Snack //
                  ListTile(
                    onTap: () {
                      timePicker(1, false, false);
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meals[1]["meal"],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          morningSnack ?? "Tap to choose reminder time",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: orange,
                                  ),
                        ),
                      ],
                    ),
                    trailing: Switch(
                      activeColor: orange,
                      inactiveTrackColor: Colors.grey[600],
                      value: morningSnackSwitch,
                      onChanged: (val) {
                        setState(() {
                          if (val == false) {
                            FirebaseNotif().cancelNotif(morningSnackId);
                          } else {
                            FirebaseNotif().scheduledNotification(
                              id: morningSnackId,
                              hour: morningSnackHour!,
                              minute: morningSnackMinutes!,
                            );
                          }
                          morningSnackSwitch = !morningSnackSwitch;
                        });
                        callApi();
                        saveMorningSnackReminder();
                      },
                    ),
                  ),
                  //! Lunch //
                  ListTile(
                    onTap: () {
                      timePicker(2, false, false);
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meals[2]["meal"],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          lunch ?? "Tap to choose reminder time",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: orange,
                                  ),
                        ),
                      ],
                    ),
                    trailing: Switch(
                      activeColor: orange,
                      inactiveTrackColor: Colors.grey[600],
                      value: lunchSwitch,
                      onChanged: (val) {
                        setState(() {
                          if (val == false) {
                            FirebaseNotif().cancelNotif(lunchId);
                          } else {
                            FirebaseNotif().scheduledNotification(
                              id: lunchId,
                              hour: lunchHour!,
                              minute: lunchMinutes!,
                            );
                          }
                          lunchSwitch = !lunchSwitch;
                        });
                        callApi();
                        saveLunchReminder();
                      },
                    ),
                  ),
                  //! Evening Snack //
                  ListTile(
                    onTap: () {
                      timePicker(3, false, false);
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meals[3]["meal"],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          eveningSnack ?? "Tap to choose reminder time",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: orange,
                                  ),
                        ),
                      ],
                    ),
                    trailing: Switch(
                      activeColor: orange,
                      inactiveTrackColor: Colors.grey[600],
                      value: eveningSnackSwitch,
                      onChanged: (val) {
                        setState(() {
                          if (val == false) {
                            FirebaseNotif().cancelNotif(eveningSnackId);
                          } else {
                            FirebaseNotif().scheduledNotification(
                              id: eveningSnackId,
                              hour: eveningSnackHour!,
                              minute: eveningSnackMinutes!,
                            );
                          }
                          eveningSnackSwitch = !eveningSnackSwitch;
                        });
                        callApi();
                        saveEveningSnackReminder();
                      },
                    ),
                  ),
                  //! Dinner //
                  ListTile(
                    onTap: () {
                      timePicker(4, false, false);
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meals[4]["meal"],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          dinner ?? "Tap to choose reminder time",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: orange,
                                  ),
                        ),
                      ],
                    ),
                    trailing: Switch(
                      activeColor: orange,
                      inactiveTrackColor: Colors.grey[600],
                      value: dinnerSwitch,
                      onChanged: (val) {
                        setState(() {
                          if (val == false) {
                            FirebaseNotif().cancelNotif(dinnerId);
                          } else {
                            FirebaseNotif().scheduledNotification(
                              id: dinnerId,
                              hour: dinnerHour!,
                              minute: dinnerMinutes!,
                            );
                          }
                          dinnerSwitch = !dinnerSwitch;
                        });
                        callApi();
                        saveDinnerReminder();
                      },
                    ),
                  ),
                  Divider(color: Colors.grey[700]!),
                  const SizedBox(height: 6),
                  // ListTile(
                  //   onTap: () {
                  //     timePicker(0, true, true);
                  //   },
                  //   title: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         "Remind me everyday at",
                  //         style: Theme.of(context).textTheme.bodyLarge,
                  //       ),
                  //       Text(
                  //         radio1Time ?? "Tap to choose reminder time",
                  //         style:
                  //             Theme.of(context).textTheme.bodyMedium!.copyWith(
                  //                   color: orange,
                  //                 ),
                  //       ),
                  //     ],
                  //   ),
                  //   trailing: Switch(
                  //     activeColor: orange,
                  //     inactiveTrackColor: Colors.grey[600],
                  //     value: isDailyReminderEnabled,
                  //     onChanged: (val) {
                  //       setState(() {
                  //         isDailyReminderEnabled = !isDailyReminderEnabled;
                  //         if (val == false) {
                  //           FirebaseNotif().cancelNotif(dailyId);
                  //         } else {
                  //           FirebaseNotif().scheduledNotification(
                  //             id: dailyId,
                  //             hour: dailyHour!,
                  //             minute: dailyMinutes!,
                  //           );
                  //         }
                  //       });
                  //       callApi();
                  //       saveRemindMeAt();
                  //     },
                  //   ),
                  // ),
                  // ListTile(
                  //   onTap: () {
                  //     timePicker(0, true, true);
                  //   },
                  //   leading: Radio(
                  //     fillColor: MaterialStateProperty.all<Color>(orange),
                  //     value: RadioButtons.dayReminder,
                  //     groupValue: radio1,
                  //     onChanged: (val) {
                  //       // log(val.toString());
                  //       setState(() {
                  //         radio1 = val;
                  //         isDailyReminderEnabled = !isDailyReminderEnabled;
                  //         log('radio is $isDailyReminderEnabled');

                  //         saveRemindMeAt();
                  //         // isWeeklyReminderEnabled = !isWeeklyReminderEnabled;
                  //       });
                  //     },
                  //     toggleable: true,
                  //   ),
                  //   title: Text(
                  //     'Remind me everyday at',
                  //     style: Theme.of(context).textTheme.bodyMedium,
                  //   ),
                  //   trailing: Text(
                  //     radio1Time ?? "Choose time",
                  //     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  //           color: orange,
                  //         ),
                  //   ),
                  // ),
                  // ListTile(
                  //   onTap: () {
                  //     showWeekdays();
                  //   },
                  //   leading: Radio(
                  //     fillColor: MaterialStateProperty.all<Color>(orange),
                  //     value: RadioButtons.radio2Day,
                  //     groupValue: radio1,
                  //     onChanged: (val) {
                  //       setState(() {
                  //         radio1 = val;
                  //         isDailyReminderEnabled = !isDailyReminderEnabled;
                  //         isWeeklyReminderEnabled = !isWeeklyReminderEnabled;
                  //       });
                  //     },
                  //   ),
                  //   title: Text(
                  //     'Remind me every week on',
                  //     style: Theme.of(context).textTheme.bodyMedium,
                  //   ),
                  //   trailing: Text(
                  //     radio2Day ?? "Choose day",
                  //     style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  //           color: orange,
                  //         ),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
  }

  void timePicker(index, bool isRadio, bool isEverdayRadio) {
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
        var tempTime =
            '${selection.hour.toString().padLeft(2, "0")}:${selection.minute.toString().padLeft(2, "0")}';

        if (isRadio == true) {
          formattedEveryReminder = tempTime;
          isDailyReminderEnabled = true;
        } else {
          if (meals[index]["meal"] == 'Breakfast') {
            breakfastTime = selection.format(context);
            formattedBreakfastTime = tempTime;
            getBreakfastTime();
            FirebaseNotif().scheduledNotification(
              id: breakfastId,
              hour: breakfastHour!,
              minute: breakfastMinutes!,
            );
            saveBreakfastReminder();
            breakfastSwitch = true;
          } else if (meals[index]["meal"] == 'Lunch') {
            lunch = selection.format(context);
            formattedLunchTime = tempTime;
            getLunchTime();
            FirebaseNotif().scheduledNotification(
              id: lunchId,
              hour: lunchHour!,
              minute: lunchMinutes!,
            );
            saveLunchReminder();
            lunchSwitch = true;
          } else if (meals[index]["meal"] == 'Dinner') {
            dinner = selection.format(context);
            formattedDinnerTime = tempTime;
            getDinnerTime();
            FirebaseNotif().scheduledNotification(
              id: dinnerId,
              hour: dinnerHour!,
              minute: dinnerMinutes!,
            );
            saveDinnerReminder();
            dinnerSwitch = true;
          } else if (meals[index]["meal"] == 'Morning Snack') {
            morningSnack = selection.format(context);
            formattedMorningSnackTime = tempTime;
            getMorningSnackTime();
            FirebaseNotif().scheduledNotification(
              id: morningSnackId,
              hour: morningSnackHour!,
              minute: morningSnackMinutes!,
            );
            saveMorningSnackReminder();
            morningSnackSwitch = true;
          } else if (meals[index]["meal"] == 'Evening Snack') {
            eveningSnack = selection.format(context);
            formattedEveningSnackTime = tempTime;
            getEveningSnackTime();
            FirebaseNotif().scheduledNotification(
              id: eveningSnackId,
              hour: eveningSnackHour!,
              minute: eveningSnackMinutes!,
            );
            saveEveningSnackReminder();
            eveningSnackSwitch = true;
          }
        }
        //!displaying time in 12hr format on the ui.
        setState(() {
          isRadio
              ? radio1Time = selection.format(context)
              : meals[index]['time'] = selection.format(context);
        });
        saveRemindMeAt();
        meals[index]['isTrue'] = true;
        // trackReminder = true;
        callApi();
      });
    });
  }

  // void showWeekdays() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         backgroundColor: Theme.of(context).canvasColor,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ListView.builder(
  //               physics: const NeverScrollableScrollPhysics(),
  //               shrinkWrap: true,
  //               itemCount: 7,
  //               itemBuilder: (context, index) {
  //                 return ListTile(
  //                   onTap: () {
  //                     setState(() {
  //                       radio2Day = weekDays[index];
  //                       formattedWeeklyReminder = radio2Day;
  //                     });
  //                     Navigator.pop(context);
  //                   },
  //                   title: Text(
  //                     weekDays[index],
  //                     style: Theme.of(context).textTheme.bodyMedium,
  //                   ),
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
