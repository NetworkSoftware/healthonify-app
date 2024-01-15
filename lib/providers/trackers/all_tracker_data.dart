import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/all_trackers.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/diet_plan_analysis.dart';
import 'package:http/http.dart' as http;

class AllTrackersData with ChangeNotifier {
  final AllTrackers _allTrackerData = AllTrackers();

  AllTrackers get allTrackersData {
    return _allTrackerData;
  }

  Future<void> getAllTrackers(String userId) async {
    String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String url = "${ApiUrl.wm}fetch/progress?userId=$userId&date=$date";
    log("get all trackers $url");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      // log(json.decode(response.body).toString());

      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as Map<String, dynamic>;
        // allTrackerData.sleepProgress = data["sleepProgress"];
        // allTrackerData.stepsProgress = data["stepsProgress"];
        // allTrackerData.waterProgress = data["waterProgress"];
        // allTrackerData.calorieProgress = data["calorieProgress"];

        _allTrackerData.totalWaterGoal =
            int.parse(data["waterProgress"]["totalWaterGoal"]);
        _allTrackerData.userWaterGlassCount =
            int.parse(data["waterProgress"]["userWaterGlassCount"]);

        _allTrackerData.totalSleepGoal =
            int.parse(data["sleepProgress"]["totalSleepGoal"]);

        print("qwertyuio : ${data["sleepProgress"]["userSleepCount"]}");
        _allTrackerData.userSleepCount =
            int.parse(data["sleepProgress"]["userSleepCount"]);

        _allTrackerData.userStepsCount =
            int.parse(data["stepsProgress"]["userStepsCount"]);
        _allTrackerData.totalStepsGoal =
            int.parse(data["stepsProgress"]["totalStepsGoal"]);

        _allTrackerData.calorieProgress = data["calorieProgress"];
        // _allTrackerData.bloodPressureLogs = data["bloodPressureLogs"];
        // _allTrackerData.hba1cLogs = data["hba1cLogs"];
        // _allTrackerData.bloodGlucoseLogs = data["bloodGlucoseLogs"];

        // log("sleep goal ${_allTrackerData.totalSleepGoal}");

        notifyListeners();
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<AllTrackers> getDiaryData(String userId, String date) async {
    String url = "${ApiUrl.wm}fetch/progress?userId=$userId&date=$date";
    AllTrackers diaryData = AllTrackers();
    log("get progress diary => $url");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      // log(json.decode(response.body).toString());

      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as Map<String, dynamic>;

        diaryData.totalWaterGoal =
            int.parse(data["waterProgress"]["totalWaterGoal"]);
        diaryData.userWaterGlassCount =
            int.parse(data["waterProgress"]["userWaterGlassCount"]);

        diaryData.totalSleepGoal =
            int.parse(data["sleepProgress"]["totalSleepGoal"]);
        diaryData.userSleepCount =
            int.parse(data["sleepProgress"]["userSleepCount"]);

        diaryData.userStepsCount =
            int.parse(data["stepsProgress"]["userStepsCount"]);
        diaryData.totalStepsGoal =
            int.parse(data["stepsProgress"]["totalStepsGoal"]);

        diaryData.calorieProgress = data["calorieProgress"];
        diaryData.bloodPressureLogs = data["bloodPressureLogs"];
        diaryData.hba1cLogs = data["hba1cLogs"];
        diaryData.bloodGlucoseLogs = data["bloodGlucoseLogs"];
        diaryData.fitnessToolsData = data["userFitnessToolsData"];

        return diaryData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  void localUpdateCalories(int value) {
    _allTrackerData.caloriesGoal = value;
    notifyListeners();
  }

  void localUpdateWaterCount(int value) {
    _allTrackerData.userWaterGlassCount = value;
    notifyListeners();
  }

  void localUpdateWaterGoal(int value) {
    _allTrackerData.totalWaterGoal = value;
    notifyListeners();
  }

  void localUpdateStepsGoal(int value) {
    _allTrackerData.totalStepsGoal = value;
    notifyListeners();
  }

  void localUpdateSteps(int value) {
    _allTrackerData.userStepsCount = value;
    notifyListeners();
  }

  void localUpdateSleepCount(int value) {
    _allTrackerData.userSleepCount;
   // _allTrackerData.userSleepCount = value;
    notifyListeners();
  }

  void localUpdateSleepGoal(int value) {
    _allTrackerData.totalWaterGoal = value;
    notifyListeners();
  }

  void localUpdateMealCalories(int value, String name) {
    log("local upate meal cals -  $name $value");
    var dietData = _allTrackerData.calorieProgress!["totalDietAnalysisData"]
        ["dietPercentagesData"] as List<dynamic>;
    for (var element in dietData) {
      if (element["name"] == name) {
        element["caloriesCount"] = value;
      }
    }

    notifyListeners();
  }

  Future<WeeklyWorkoutsModel> getWeeklyActivity(
      Map<String, dynamic> data) async {
    String url = "${ApiUrl.wm}user/getWeeklyWorkoutsData";

    print("url : $url");
    WeeklyWorkoutsModel workoutsModel = WeeklyWorkoutsModel();
    log(data.toString());
    try {
      final response = await http.post(Uri.parse(url), body: data);
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      log(json.decode(response.body).toString());

      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as Map<String, dynamic>;

        workoutsModel = WeeklyWorkoutsModel.fromJson(data);

        return workoutsModel;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<DietAnalysis> getDietAnalysis(String userId, String date) async {
    var dateFormat = DateFormat("yyyy-MM-dd").parse(date);
    var fromDate = dateFormat.subtract(const Duration(days: 7));
    var formattedFromDate = DateFormat("yyyy-MM-dd").format(fromDate);
    String url =
        "${ApiUrl.wm}fetch/dietAnalysis?userId=$userId&fromDate=$formattedFromDate&toDate=$date";
    DietAnalysis dietAnalysis = DietAnalysis();
    log("get diet analysis  => $url");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      // log(json.decode(response.body).toString());

      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as Map<String, dynamic>;
        dietAnalysis = DietAnalysis.fromJson(data);

        return dietAnalysis;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
