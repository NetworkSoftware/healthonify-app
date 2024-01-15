import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/home_tracker_model/home_tracker_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class HomeTrackerProvider with ChangeNotifier {
  Future<HomeTrackerModel> getHomeTrackerData(String userId) async {
    String url = "${ApiUrl.wm}fetch/progress?userId=$userId";
    log(url);
    HomeTrackerModel loadedData = HomeTrackerModel();
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
        final data = responseData['data'];

        loadedData = HomeTrackerModel(
          calorieProgress: CalorieProgress.fromJson(data["calorieProgress"]),
          sleepProgress: SleepProgress.fromJson(data["sleepProgress"]),
          stepsProgress: StepsProgress.fromJson(data["stepsProgress"]),
          waterProgress: WaterProgress.fromJson(data["waterProgress"]),
          bloodPressureLogs: List<BloodPressureLog>.from(
            data["bloodPressureLogs"].map(
              (x) => BloodPressureLog.fromJson(x),
            ),
          ),
          hba1CLogs: List<Hba1CLog>.from(
            data["hba1cLogs"].map(
              (x) => Hba1CLog.fromJson(x),
            ),
          ),
          bloodGlucoseLogs: List<BloodGlucoseLog>.from(
            data["bloodGlucoseLogs"].map(
              (x) => BloodGlucoseLog.fromJson(x),
            ),
          ),
        );

        log('fetched home tracker');
        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
