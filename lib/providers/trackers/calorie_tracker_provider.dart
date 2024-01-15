import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/tracker_models/calorie_model.dart';
import 'package:http/http.dart' as http;

enum CalorieAction { add, sub }

class CalorieTrackerProvider with ChangeNotifier {
  final CalorieModel calorieData = CalorieModel();

  Future<void> getCalories(String data) async {
    String url = '${ApiUrl.wm}user/fetchTotalCalories$data';
    log("get calories $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        log("get calories response $responseData");

        calorieData.totalConsumedCalories =
            responseData["data"]["caloriesData"]["totalConsumedCalories"];
        calorieData.totalBurntCalories =
            responseData["data"]["caloriesData"]["totalBurntCalories"];
        calorieData.caloriesConsumptionGoal =
            responseData["data"]["caloriesData"]["caloriesConsumptionGoal"];
        calorieData.caloriesBurntGoal =
            responseData["data"]["caloriesData"]["caloriesBurntGoal"];
        calorieData.stepsCalorie =
        responseData["data"]["caloriesData"]["stepsCalorie"];

        log("Calories fetched ");

        notifyListeners();
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setCaloriesGoal(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}user/updateCalories';

    log("set calories  $url");

    log(data.toString());

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        // log(responseData['message']);

        calorieData.caloriesConsumptionGoal = data["calorieIntake"].toString();
        calorieData.caloriesBurntGoal = data["caloriesBurntGoal"].toString();

        notifyListeners();
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  void updateCaloriesTrackerConsumption(
    String value,
  ) {
    log("calories consumed $value");
    calorieData.totalConsumedCalories =
        (double.parse(value).round()).toString();
    notifyListeners();
  }

  void updateCaloriesTrackerExercise(
      String value,
      ) {
    log("calories exercise $value");
    calorieData.totalBurntCalories =
        (double.parse(value).round()).toString();
    notifyListeners();
  }

  void updateBaseGoal(String value) {
    log("updated calorie goal $value");
    calorieData.caloriesConsumptionGoal = value;
    notifyListeners();
  }
}
