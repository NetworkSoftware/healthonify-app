import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/reminder_models/reminder_models.dart';
import 'package:http/http.dart' as http;

class ReminderProvider with ChangeNotifier {
  Future postMealReminder(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}/post/mealReminder';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      log(responseData.toString());

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        log(responseData["message"]);
        // final mealData =
        //     json.decode(response.body)["data"] as Map<String, dynamic>;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MealReminder>> getMealReminders(String userId) async {
    List<MealReminder> mealReminder = [];

    String url = '${ApiUrl.wm}/get/mealReminder?userId=$userId';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          mealReminder.add(
            MealReminder(
              userId: ele["userId"],
              breakfast: ele["breakfast"],
              morningSnack: ele["morningSnack"],
              lunch: ele["lunch"],
              eveningSnack: ele["eveningSnack"],
              dinner: ele["dinner"],
              reminderEnabled: ele["reminderEnabled"],
              remindmeEverydayAt: ele["remindmeEverydayAt"],
              remindmeEveryweekAt: ele["remindmeEveryweekAt"],
              dailyreminderEnabled: ele["dailyreminderEnabled"],
              weeklyreminderEnabled: ele["weeklyreminderEnabled"],
            ),
          );
        }

        return mealReminder;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future postWaterReminder(Map<String, dynamic> map) async {
    String url = '${ApiUrl.wm}/post/waterReminder';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(map),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      log(responseData.toString());

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        log(responseData["message"]);
        final waterData =
            json.decode(response.body)["data"] as Map<String, dynamic>;

        log(waterData.toString());
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WaterReminder>> getWaterReminders(String userId) async {
    List<WaterReminder> waterReminderData = [];

    String url = '${ApiUrl.wm}/get/waterReminder?userId=$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          waterReminderData.add(
            WaterReminder(
              hourlyReminder: ele["hourlyReminder"],
              hourlyReminderEnabled: ele["hourlyReminderEnabled"],
              reminderEnabled: ele["reminderEnabled"],
              reminderFromTime: ele["reminderFromTime"],
              reminderTimes: ele["reminderTimes"],
              reminderTimesEnabled: ele["reminderTimesEnabled"],
              reminderToTime: ele["reminderToTime"],
              userId: ele["userId"],
            ),
          );
        }

        return waterReminderData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future postSleepReminder(Map<String, dynamic> map) async {
    String url = '${ApiUrl.wm}/post/sleepReminder';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(map),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      log(responseData.toString());

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        log(responseData["message"]);
        final sleepData =
            json.decode(response.body)["data"] as Map<String, dynamic>;

        log(sleepData.toString());
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SleepReminder>> getSleepReminders(String userId) async {
    List<SleepReminder> sleepReminders = [];

    String url = '${ApiUrl.wm}/get/sleepReminder?userId=$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          sleepReminders.add(
            SleepReminder(
              sleepTime: ele["sleepTime"],
              sleepTimeReminderEnabled: ele["sleepTimeReminderEnabled"],
              userId: ele["userId"],
              wakeupTime: ele["wakeupTime"],
              wakeupTimeReminderEnabled: ele["wakeupTimeReminderEnabled"],
            ),
          );
        }

        return sleepReminders;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future postStepsReminder(Map<String, dynamic> map) async {
    String url = '${ApiUrl.wm}/post/walkReminder';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(map),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      // log(responseData.toString());

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        log(responseData["message"]);
        final stepsData =
            json.decode(response.body)["data"] as Map<String, dynamic>;

        log(stepsData.toString());
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StepsReminder>> getStepsReminders(String userId) async {
    List<StepsReminder> stepsReminders = [];

    String url = '${ApiUrl.wm}/get/walkReminder?userId=$userId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          stepsReminders.add(
            StepsReminder(
              remindMeAt: ele["remindMeAt"],
              remindMeEnabled: ele["remindMeEnabled"],
              userId: ele["userId"],
              walkReminderEnabled: ele["walkReminderEnabled"],
            ),
          );
        }

        return stepsReminders;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
