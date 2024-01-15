class MealReminder {
  bool? reminderEnabled;
  bool? dailyreminderEnabled;
  bool? weeklyreminderEnabled;
  String? userId;
  String? breakfast;
  String? dinner;
  String? eveningSnack;
  String? lunch;
  String? morningSnack;
  String? remindmeEverydayAt;
  String? remindmeEveryweekAt;
  MealReminder({
    this.breakfast,
    this.dailyreminderEnabled,
    this.dinner,
    this.eveningSnack,
    this.lunch,
    this.morningSnack,
    this.reminderEnabled,
    this.remindmeEverydayAt,
    this.remindmeEveryweekAt,
    this.userId,
    this.weeklyreminderEnabled,
  });
}

class WaterReminder {
  bool? reminderEnabled;
  bool? hourlyReminderEnabled;
  bool? reminderTimesEnabled;
  int? hourlyReminder;
  int? reminderTimes;
  String? reminderFromTime;
  String? reminderToTime;
  String? userId;

  WaterReminder({
    this.hourlyReminder,
    this.hourlyReminderEnabled,
    this.reminderEnabled,
    this.reminderFromTime,
    this.reminderTimes,
    this.reminderTimesEnabled,
    this.reminderToTime,
    this.userId,
  });
}

class SleepReminder {
  String? userId;
  String? sleepTime;
  String? wakeupTime;
  bool? sleepTimeReminderEnabled;
  bool? wakeupTimeReminderEnabled;

  SleepReminder({
    this.sleepTime,
    this.sleepTimeReminderEnabled,
    this.userId,
    this.wakeupTime,
    this.wakeupTimeReminderEnabled,
  });
}

class StepsReminder {
  String? userId;
  String? remindMeAt;
  bool? remindMeEnabled;
  bool? walkReminderEnabled;
  StepsReminder({
    this.remindMeAt,
    this.remindMeEnabled,
    this.userId,
    this.walkReminderEnabled,
  });
}
