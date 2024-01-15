import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/hra_model/hra_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class HraProvider with ChangeNotifier {
  Future getQuestions() async {
    List<HraModel> hraQuestions = [];

    String url = '${ApiUrl.hc}get/hraQuestions';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpException(responseBody["message"]);
      }
      if (responseBody['status'] == 1) {
        final responseData =
            json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in responseData) {
          hraQuestions.add(
            HraModel(
              questionId: ele["_id"],
              question: ele["question"],
              order: ele["order"],
              options: List<Options>.from(
                ele["options"].map((x) => Options.fromJson(x)),
              ),
            ),
          );
        }
        return hraQuestions;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateHraDetails(
      {String? userId,
      String? weight,
      String? height,
      String? waist,
      String? age,
      String? gender}) async {
    String url = '${ApiUrl.hc}put/user?id=$userId';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "set": {
            "waistInCms": "$waist",
            "heightInCms": "$height",
            "weightInKgs": "$weight",
            "age": "$age",
            "gender": "$gender"
          }
        }),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        log(json.encode(responseData));
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postHraAnswers(Map<String, dynamic> data) async {
    String url = '${ApiUrl.hc}hraReport/storeHraAnswers';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        log(json.encode(responseData));
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future getHraScore(String userId) async {
    List<HraAnswerModel> hraAnswers = [];
    String url = '${ApiUrl.hc}get/hraAnswers?userId=$userId';

    log(url);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpException(responseBody["message"]);
      }
      if (responseBody['status'] == 1) {
        final responseData =
            json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in responseData) {
          hraAnswers.add(
            HraAnswerModel(
              id: ele["_id"],
              userId: ele["userId"],
              reportUrl: ele["hraReportUrl"],
              answers: List<AnswersModel>.from(
                ele["answers"].map((x) => AnswersModel.fromJson(x)),
              ),
              hraScore: ele["hraScore"],
              maxScore: ele["maxScore"],
              createdAt: ele["created_at"],
            ),
          );
        }
        return hraAnswers;
      } else {
        throw HttpException(responseBody["message"]);
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
