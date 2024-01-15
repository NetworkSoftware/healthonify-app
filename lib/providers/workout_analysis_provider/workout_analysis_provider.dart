import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/workout_analysis_model/workout_analysis_model.dart';
import 'package:http/http.dart' as http;

class WorkoutAnalysisProvider with ChangeNotifier {
  Future<WorkoutAnalysisModel> getWorkoutAnalysis(
      String userId, String dateFilter) async {
    String url = "${ApiUrl.wm}fetch/workoutAnalysis?userId=$userId$dateFilter";
    log(url);
    WorkoutAnalysisModel loadedData = WorkoutAnalysisModel();
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
        final data = json.decode(response.body)['data'] as Map<String, dynamic>;

        log("workout analysis data => $data");

        loadedData = WorkoutAnalysisModel(
          totalCalories: data["totalCalories"],
          totalSets: data["totalSets"],
          totalReps: data["totalReps"],
          totalVolumeInKgs: data["totalVolumeInKgs"],
          totalWorkouts: data["totalWorkouts"],
          workoutPercentagesData: data["workoutPercentagesData"] == null
              ? []
              : List<WorkoutPercentagesDatum>.from(
                  data["workoutPercentagesData"].map(
                    (x) => WorkoutPercentagesDatum.fromJson(x),
                  ),
                ),
        );

        log('fetched workout analysis');
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
