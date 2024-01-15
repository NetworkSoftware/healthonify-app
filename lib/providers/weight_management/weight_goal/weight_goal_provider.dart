import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/goals_model.dart';
import 'package:http/http.dart' as http;

class WeightGoalProvider with ChangeNotifier {
  Future<void> postWeightGoals(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}post/weightGoal';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        log(responseData.toString());
        log(responseData['message']);
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WeightGoalModel>> getWeightGoals(String userId) async {
    String url = '${ApiUrl.wm}get/weightGoal?userId=$userId';
    log("weight goal $url");

    final List<WeightGoalModel> loadedData = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);

      log(responseBody.toString());

      if (response.statusCode >= 400) {
        throw HttpException(responseBody["message"]);
      }
      if (responseBody["status"] == 1) {
        final responseData = json.decode(response.body)["data"];
        for (var element in responseData) {
          loadedData.add(
            WeightGoalModel(
              activityLevel: element['activityLevel'],
              currentWeight: element['currentWeight'].toString(),
              date: element['date'],
              goalWeight: element['goalWeight'].toString(),
              userId: element['userId'],
              weeklyGoal: element['weeklyGoal'],
              startingWeight: element['startingWeight'].toString(),
              goalCalories: element['goalCalories'].toString()
            ),
          );
        }
        return loadedData;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      throw HttpException('$e');
    }
  }
}
