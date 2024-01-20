import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/exercise/exercise.dart';
import 'package:healthonify_mobile/models/exercise/exercise_log_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

import '../../models/exercise/exercise_directions_model.dart';

class ExercisesData with ChangeNotifier {
  Future<List<Exercise>> fetchExercises({required String data}) async {
    String url = "${ApiUrl.wm}get/exercise?$data";

    log("get exercise : $url");
    final List<Exercise> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData =
            json.decode(response.body)["data"] as List<dynamic>;
        for (var element in responseData) {
          loadedData.add(Exercise(
              bodyPartId: element['bodyPartId'],
              bodyPartGroupId: element['bodyPartGroupId'],
              mediaLink: element["mediaLink"],
              name: element["name"],
              weightUnit: element["weight"],
              id: element["_id"],
              calorieFactor: element["calorieFactor"],
              description: element["description"]));
        }

        return loadedData;
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ExerciseDirection>> fetchExerciseDirection(
      {required String data}) async {
    String url = "${ApiUrl.wm}get/exercise?id=$data";

    log("get exercise : $url");
    final List<ExerciseDirection> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData =
            json.decode(response.body)["data"] as List<dynamic>;
        for (var element in responseData) {
          loadedData.add(ExerciseDirection(
              bodyPartId: element['bodyPartId'],
              bodyPartGroupId: element['bodyPartGroupId'],
              mediaLink: element["mediaLink"],
              name: element["name"],
              weightUnit: element["weight"].toString(),
              id: element["_id"],
              calorieFactor: element["calorieFactor"],
              description: element["description"]));
        }

        return loadedData;
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e, trace) {
      log(trace.toString());
      rethrow;
    }
  }

  Future<List<Exercise>> searchExercise(
      {required String page,
      required String query,
      required String bodyPartId,
      String? userId = ""}) async {
    String bodyPartIdExt = "";
    String userIdExt = "";

    if (bodyPartId.isNotEmpty) {
      bodyPartIdExt = "&bodyPartId=$bodyPartId";
    }
    if (userId != null && userId.isNotEmpty) {
      userIdExt = "&userId=$userId";
    }
    String url =
        "${ApiUrl.wm}search/exercise?query=$query&page=$page&limit=20$bodyPartIdExt$userIdExt";
    log("search exercise : $url");
    final List<Exercise> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData =
            json.decode(response.body)["data"] as List<dynamic>;
        for (var element in responseData) {
          loadedData.add(Exercise(
            bodyPartId: element['bodyPartId'],
            bodyPartGroupId: element['bodyPartGroupId'],
            mediaLink: element["mediaLink"],
            name: element["name"],
            weightUnit: element["weight"].toString(),
            id: element["id"],
          ));
        }
        log("fetched ex succesfully");
        return loadedData;
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e, trace) {
      log("Trace : $trace");
      rethrow;
    }
  }

  Future<void> postExercise(Map data) async {
    String url = "${ApiUrl.wm}post/exercise";
    log("post exercise : $url");
    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        // final responseData =
        //     json.decode(response.body)["data"] as List<dynamic>;

        log("posted ex succesfully");
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postExLog(Map data) async {
    String url = "${ApiUrl.wm}user/storeExerciseLog";
    log("post exercise : $url");
    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        // final responseData =
        //     json.decode(response.body)["data"] as List<dynamic>;

        log("ex logged succesfully");
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ExerciseLogList>> getExLogs(String data) async {
    String url = "${ApiUrl.wm}get/exerciseLogs?$data";
    List<ExerciseLogList> loadedData = [];
    log("get exercise logs : $url");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData =
            json.decode(response.body)["data"] as List<dynamic>;
        loadedData = List<ExerciseLogList>.from(
          responseData.map(
            (x) => ExerciseLogList.fromJson(x),
          ),
        );

        log("ex log get succesful");
        return loadedData;
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e, trace) {
      log("Trace : $trace");
      rethrow;
    }
  }
}
