import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  String sessionMobile = "Session";
  String userId = "userid";
  String mobile = "mobile";
  String email = "email";
  String message = "message";
  String accessToken = "ACtoken";
  String roles = "Roles";
  String isTopExpPresent = "IS_TOP_EXP_PRESENT";
  String isStepTrackerEnabled = "IS_STEP_TRACKER_ENABLED";

  Future<void> saveSession(bool session) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(sessionMobile, session);
  }

  Future<bool> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value;
    value = prefs.getBool(sessionMobile) ?? false;
    return value;
  }

  Future<String> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value;
    value = prefs.getString(mobile) ?? "";
    return value;
  }

  Future<void> saveLoginDetails(String? id, String? mobile, String? email,
      String? accessToken, String? roles) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userId, id!);
    prefs.setString(this.mobile, mobile!);
    prefs.setString(this.email, email!);
    prefs.setString(this.accessToken, accessToken!);
    prefs.setString(this.roles, roles!);
  }

  Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.userId, userId);
  }

  Future<String> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value;
    value = prefs.getString(userId) ?? "";
    return value;
  }

  Future<void> saveRoles(String roles) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.roles, roles);
  }

  Future<String> getRoles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(roles);
    return value!;
  }

  Future<void> saveIsTopExp(bool isSet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isTopExpPresent, isSet);
  }

  Future<bool> getIsTopExp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(isTopExpPresent) ?? false;
    return value;
  }

  Future<void> saveStepTrackerEnabled(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isStepTrackerEnabled, value);
  }

  Future<bool> getStepTrackerEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(isStepTrackerEnabled) ?? false;


    return value;
  }
}

class ReminderSharedPref {
  //meal
  String mealReminderEnabled = "mealReminderEnabled",
      bfReminderEnabled = "bfReminderEnabled",
      morningSnackEnabled = "morningSnackEnabled",
      lunchEnabled = "lunchEnabled",
      eveningSnackEnabled = "eveningSnackEnabled",
      dinnerEnabled = "dinnerEnabled",
      mealReminderAtEnabled = "mealReminderAtEnabled";

  String bfReminderTime = "bfReminderTime",
      morningSncakTime = "morningSncakTime",
      lunchTime = "lunchTime",
      eveningSnackTime = "eveningSnackTime",
      dinnerTime = "dinnerTime",
      mealReminderTime = "mealReminderTime";

  //steps
  String stepsReminderTime = "stepsReminderTime";
  String stepsReminderEnabled = "stepsReminderEnabled";

  //sleep
  String sleepTime = "sleepTime", wakeupTime = "wakeupTime";
  String pillRemiders = 'PillsReminders';
  String isSleepReminderEnabled = "isSleepReminderEnabled",
      isWakeUpReminderEnabled = "isWakeUpReminderEnabled";

  //water
  String waterReminderEnabled = "waterReminderEnabled";
  String waterReminderFromTime = "waterReminderFromTime";
  String waterReminderToTime = "waterReminderToTime";
  String waterReminderInterval = "waterReminderInterval";
  String waterReminderFrequency = "waterReminderFrequency";
  String isFirstRadioBool = "isFirstRadioBool";

  Future<void> saveWaterReminderTracker({required bool enabled}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(waterReminderEnabled, enabled);
  }

  Future<void> saveWaterReminderFromTime({required String time}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(waterReminderFromTime, time);
  }

  Future<void> saveWaterReminderToTime({required String time}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(waterReminderToTime, time);
  }

  Future<void> saveWaterReminderInterval(
      {required int interval, required bool isSelected}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(waterReminderInterval, interval);
    prefs.setBool(isFirstRadioBool, isSelected);
  }

  Future<void> saveWaterReminderFrequency(
      {required int frequency, required bool isSelected}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(waterReminderFrequency, frequency);
    prefs.setBool(isFirstRadioBool, isSelected);
  }

  Future<Map<String, dynamic>> getWaterReminderPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value;
    String fromTime;
    String toTime;
    int interval;
    int frequency;
    bool isFirstRadioSelected;
    value = prefs.getBool(waterReminderEnabled) ?? false;
    fromTime = prefs.getString(waterReminderFromTime) ?? "09:00";
    toTime = prefs.getString(waterReminderToTime) ?? "21:00";
    interval = prefs.getInt(waterReminderInterval) ?? 1;
    frequency = prefs.getInt(waterReminderFrequency) ?? 3;
    isFirstRadioSelected = prefs.getBool(isFirstRadioBool) ?? false;
    return {
      "isEnabled": value,
      "fromTime": fromTime,
      "toTime": toTime,
      "interval": interval,
      "frequency": frequency,
      "isFirstRadioSelected": isFirstRadioSelected,
    };
  }

  Future<void> saveMealReminderTracker({required bool enabled}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(mealReminderEnabled, enabled);
  }

  Future<bool> getMealReminderTracker() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value;
    value = prefs.getBool(mealReminderEnabled) ?? false;
    return value;
  }

  Future<void> saveBreakfastPreferences(
      {required bool enabled, required String time}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(bfReminderEnabled, enabled);
    prefs.setString(bfReminderTime, time);
  }

  Future<Map<String, dynamic>> getBreakfastPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value;
    String time;
    value = prefs.getBool(bfReminderEnabled) ?? false;
    time = prefs.getString(bfReminderTime) ?? "07:00";
    return {"isEnabled": value, "time": time};
  }

  Future<void> saveLunchPreferences(
      {required bool enabled, required String time}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(lunchEnabled, enabled);
    prefs.setString(lunchTime, time);
  }

  Future<Map<String, dynamic>> getLunchPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value;
    String time;
    value = prefs.getBool(lunchEnabled) ?? false;
    time = prefs.getString(lunchTime) ?? "13:00";
    return {"isEnabled": value, "time": time};
  }

  Future<void> saveDinnerPreferences(
      {required bool enabled, required String time}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(dinnerEnabled, enabled);
    prefs.setString(dinnerTime, time);
  }

  Future<Map<String, dynamic>> getDinnerPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value;
    String time;
    value = prefs.getBool(dinnerEnabled) ?? false;
    time = prefs.getString(dinnerTime) ?? "20:00";
    return {"isEnabled": value, "time": time};
  }

  Future<void> saveMorningSnackPreferences(
      {required bool enabled, required String time}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(morningSnackEnabled, enabled);
    prefs.setString(morningSncakTime, time);
  }

  Future<Map<String, dynamic>> getMorningSnackPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value;
    String time;
    value = prefs.getBool(morningSnackEnabled) ?? false;
    time = prefs.getString(morningSncakTime) ?? "10:00";
    return {"isEnabled": value, "time": time};
  }

  Future<void> saveEveningSnackPreferences(
      {required bool enabled, required String time}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(eveningSnackEnabled, enabled);
    prefs.setString(eveningSnackTime, time);
  }

  Future<Map<String, dynamic>> getEveningSnackPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value;
    String time;
    value = prefs.getBool(eveningSnackEnabled) ?? false;
    time = prefs.getString(eveningSnackTime) ?? "16:00";
    return {"isEnabled": value, "time": time};
  }

  Future<void> saveMealReminderTime(
      {required bool enabled, required String time}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(mealReminderAtEnabled, enabled);
    prefs.setString(mealReminderTime, time);
  }

  Future<Map<String, dynamic>> getMealReminderTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value;
    String time;
    value = prefs.getBool(mealReminderAtEnabled) ?? false;
    time = prefs.getString(mealReminderTime) ?? "09:00";
    return {"isEnabled": value, "time": time};
  }

  Future<void> saveStepsReminder(
      {required bool enabled, required String time}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(stepsReminderEnabled, enabled);
    prefs.setString(stepsReminderTime, time);
  }

  Future<Map<String, dynamic>> getStepsReminder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value;
    String time;
    value = prefs.getBool(stepsReminderEnabled) ?? false;
    time = prefs.getString(stepsReminderTime) ?? "09:30";
    return {"isEnabled": value, "time": time};
  }

  Future<void> saveSleepReminder(
      {required bool enabled, required String time}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isSleepReminderEnabled, enabled);
    prefs.setString(sleepTime, time);
  }

  Future<Map<String, dynamic>> getSleepReminder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value;
    String time;
    value = prefs.getBool(isSleepReminderEnabled) ?? false;
    time = prefs.getString(sleepTime) ?? "22:00";
    return {"isEnabled": value, "time": time};
  }

  Future<void> saveWakeUpReminder(
      {required bool enabled, required String time}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isWakeUpReminderEnabled, enabled);
    prefs.setString(wakeupTime, time);
  }
  Future<void> savePillReminder(
      {required List reminders}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temp = jsonEncode(reminders);
    
    prefs.setString(pillRemiders, temp);
  }
  Future<List> getPillReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temp = prefs.getString(pillRemiders);
    return jsonDecode(temp!);
  }
  Future<Map<String, dynamic>> getWakeUpReminder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value;
    String time;
    value = prefs.getBool(isWakeUpReminderEnabled) ?? false;
    time = prefs.getString(wakeupTime) ?? "05:00";
    return {"isEnabled": value, "time": time};
  }
}
