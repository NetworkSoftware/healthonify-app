import 'dart:convert';
import 'dart:developer';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/vitals/all_vitals.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BloodPressureData with ChangeNotifier {
  final BloodPressure _bpData = BloodPressure();

  BloodPressure get bpData {
    return _bpData;
  }

  Future<void> getBpData(String userId, String dateType) async {
    log("this is inside provider $userId");
    String url =
        "${ApiUrl.wm}fetchLogs/userBloodPressure?userId=$userId&dateType=$dateType";

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
        _bpData.latestData = data["latestData"];
        _bpData.averageData = data["averageData"];
        _bpData.minimumData = data["minimumData"];
        _bpData.maximumData = data["maximumData"];
        _bpData.recentLogs = (data["recentLogs"] as List<dynamic>)
            .map(
              (item) => BpRecentLogs(
                  id: item["_id"],
                  date: item["date"],
                  userId: item["userId"],
                  diastolic: item["diastolic"],
                  systolic: item["systolic"],
                  pulse: item["pulse"],
                  time: item["time"]),
            )
            .toList();

        // log(data.toString());
        log('fetched blood pressure');
        notifyListeners();
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> storeBpData(Map<String, String> data) async {
    String url = "${ApiUrl.wm}store/bloodPressureLogs";

    log(url);
    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
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

  Future<void> editBpData(
    Map<String, dynamic> data,
    String bloodPressureId,
  ) async {
    String url = "${ApiUrl.wm}put/userBloodPressure?id=$bloodPressureId";

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
