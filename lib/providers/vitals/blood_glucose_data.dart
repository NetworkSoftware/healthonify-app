import 'dart:convert';
import 'dart:developer';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/vitals/all_vitals.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:intl/message_lookup_by_library.dart';

class BloodGlucoseData with ChangeNotifier {
  Future<BloodGlucose> getBloodGlucose(String userId, String dateType) async {
    String url =
        "${ApiUrl.wm}fetchLogs/userBloodGlucose?userId=$userId&dateType=$dateType";

    print("url :$url");

    BloodGlucose bloodGlucose = BloodGlucose();

    log(url);
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
        bloodGlucose.averageData = data["averageData"];
        bloodGlucose.recentLogs = data["recentLogs"] == null
            ? null
            : (data["recentLogs"] as List<dynamic>)
                .map(
                  (item) => BloodGlucoseRecentLogs(
                    id: item["_id"],
                    date: item["date"],
                    userId: item["userId"],
                    bloodGlucoseLevel: item["bloodGlucoseLevel"],
                    testType: item["testType"],
                    time: item["time"],
                    mealType: item["mealType"],
                  ),
                )
                .toList();
        log(bloodGlucose.averageData.toString());
        // log(data.toString());
        log('fetched blood glucose');
        return bloodGlucose;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> storeBloodGlucose(Map<String, String> data) async {
    String url = "${ApiUrl.wm}store/bloodGlucoseLogs";

    log(url);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> editBloodGlucose(
      Map<String, dynamic> data, String bloodGlucoseId) async {
    String url = "${ApiUrl.wm}put/userBloodGlucose?id=$bloodGlucoseId";

    log(url);
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
