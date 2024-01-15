import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class HeartRateTrackerProvider with ChangeNotifier {
  Future<void> postHRLogs(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}user/storeHeartRateLogs';
    //add for manually adding

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
        // log(responseData.toString());
        // Fluttertoast.showToast(msg: 'Heart rate Log stored successfully');
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<HeartRate>> getHRLogs(String data, bool isWeekly) async {
    String url = '${ApiUrl.wm}user/fetchHeartRateLogs$data';

    log("Heart rate fetch url $url ");

    List<HeartRateData> heartRateData = [];
    List<HeartRate> hrData = [];

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
        if (isWeekly == true) {
          String todaysDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
          List previousWeek = [];
          DateTime startDate = DateFormat('yyyy-MM-dd')
              .parse(todaysDate)
              .subtract(const Duration(days: 7));
          DateTime endDate = DateFormat('yyyy-MM-dd').parse(todaysDate);

          while (endDate.isAfter(startDate)) {
            startDate = startDate.add(
              const Duration(days: 1),
            );
            previousWeek.add(startDate);
          }

          List fdate = [];

          for (var dates in previousWeek) {
            var fDates = DateFormat('yyyy-MM-dd').format(dates);
            fdate.add(fDates);
          }

          int matchesFound = 0;

          for (var ele = 0; ele < fdate.length; ele++) {
            String? apiDate, apiDateInMs, fDateInMs;
            String? apiTemp;

            var fDateTime = DateFormat('yyyy-MM-dd').parse(fdate[ele]);
            fDateInMs = fDateTime.millisecondsSinceEpoch.toString();

            for (var i = 0; i < responseData["data"].length; i++) {
              apiDate = responseData["data"][i]["date"];

              var apiDateTime = DateFormat('yyyy-MM-dd').parse(apiDate!);

              apiTemp = DateFormat('yyyy-MM-dd').format(apiDateTime);
              apiDateInMs = apiDateTime.millisecondsSinceEpoch.toString();

              if (fdate[ele] == apiTemp) {
                matchesFound += 1;
                hrData.add(
                  HeartRate(
                    date: apiDateInMs,
                    avgHr: int.parse(
                      responseData["data"][i]["averageHeartRateData"],
                    ),
                    maxHr: double.parse(responseData["data"][i]["maximumHeartRateValue"].toString()),
                    minHr: double.parse(responseData["data"][i]["minimumHeartRateValue"].toString()),
                  ),
                );
                break;
              }
            }
            if (fdate[ele] != apiTemp) {
              hrData.add(
                HeartRate(date: fDateInMs, avgHr: 0, maxHr: 0, minHr: 0),
              );
            }
          }
        } else {
          for (var ele in responseData["data"]) {
            hrData.add(
              HeartRate(
                avgHr: int.parse(ele["averageHeartRateData"]),
                maxHr: double.parse(ele["maximumHeartRateValue"].toString()),
                minHr: double.parse(ele["minimumHeartRateValue"].toString()),
                date: ele["date"]
              ),
            );

            heartRateData = List<HeartRateData>.from(
              ele["platformData"].map(
                (x) => HeartRateData.fromJson(x),
              ),
            );
          }
        }
        return hrData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<HeartRate>> getHRHistoryLogs(String data, bool isWeekly) async {
    String url = '${ApiUrl.wm}user/fetchHeartRateLogs$data';

    log("Heart rate fetch url1 $url ");

    List<HeartRateData> heartRateData = [];
    List<HeartRate> hrData = [];

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
        if (isWeekly == true) {
          String todaysDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
          List previousWeek = [];
          DateTime startDate = DateFormat('yyyy-MM-dd')
              .parse(todaysDate)
              .subtract(const Duration(days: 7));
          DateTime endDate = DateFormat('yyyy-MM-dd').parse(todaysDate);

          while (endDate.isAfter(startDate)) {
            startDate = startDate.add(
              const Duration(days: 1),
            );
            previousWeek.add(startDate);
          }

          List fdate = [];

          for (var dates in previousWeek) {
            var fDates = DateFormat('yyyy-MM-dd').format(dates);
            fdate.add(fDates);
          }

          int matchesFound = 0;

          for (var ele = 0; ele < fdate.length; ele++) {
            String? apiDate, apiDateInMs, fDateInMs;
            String? apiTemp;

            var fDateTime = DateFormat('yyyy-MM-dd').parse(fdate[ele]);
            fDateInMs = fDateTime.millisecondsSinceEpoch.toString();

            for (var i = 0; i < responseData["data"].length; i++) {
              apiDate = responseData["data"][i]["date"];

              var apiDateTime = DateFormat('yyyy-MM-dd').parse(apiDate!);

              apiTemp = DateFormat('yyyy-MM-dd').format(apiDateTime);
              apiDateInMs = apiDateTime.millisecondsSinceEpoch.toString();

              if (fdate[ele] == apiTemp) {
                matchesFound += 1;
                hrData.add(
                  HeartRate(
                    date: apiDateInMs,
                    avgHr: int.parse(
                      responseData["data"][i]["averageHeartRateData"],
                    ),
                    maxHr: responseData["data"][i]["maximumHeartRateValue"],
                    minHr: responseData["data"][i]["minimumHeartRateValue"],
                  ),
                );
                break;
              }
            }
            if (fdate[ele] != apiTemp) {
              hrData.add(
                HeartRate(date: fDateInMs, avgHr: 0, maxHr: 0, minHr: 0),
              );
            }
          }
        } else {
          for (var ele in responseData["data"]) {
            hrData.add(
              HeartRate(
                avgHr: int.parse(ele["averageHeartRateData"]),
                maxHr: double.parse(ele["maximumHeartRateValue"].toString()),
                minHr: double.parse(ele["minimumHeartRateValue"].toString()),
                  date: ele["date"]
              ),
            );

            heartRateData = List<HeartRateData>.from(
              ele["platformData"].map(
                    (x) => HeartRateData.fromJson(x),
              ),
            );
          }
        }
        return hrData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}

class HeartRate {
  HeartRate({
    this.userId,
    this.date,
    this.heartRateData,
    this.minHr,
    this.maxHr,
    this.avgHr,
  });

  String? userId;
  String? date;
  List<HeartRateData>? heartRateData;
  double? minHr;
  double? maxHr;
  int? avgHr;

  factory HeartRate.fromJson(Map<String, dynamic> json) => HeartRate(
        userId: json["userId"],
        date: json["date"],
        minHr: json["minimumHeartRateValue"],
        maxHr: json["maximumHeartRateValue"],
        avgHr: json["averageHeartRateData"],
        heartRateData: List<HeartRateData>.from(
            json["heartRateData"].map((x) => HeartRateData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "date": date,
        "averageHeartRateData": avgHr,
        "maximumHeartRateValue": maxHr,
        "minimumHeartRateValue": minHr,
        "heartRateData":
            List<dynamic>.from(heartRateData!.map((x) => x.toJson())),
      };
}

class HeartRateData {
  HeartRateData({
    this.value,
    this.platform,
    this.time,
  });

  int? value;
  String? platform;
  String? time;

  factory HeartRateData.fromJson(Map<String, dynamic> json) => HeartRateData(
        value: json["value"],
        platform: json["platform"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "platform": platform,
        "time": time,
      };
}
