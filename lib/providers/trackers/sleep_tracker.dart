import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/widgets/drop_downs/filter_dropdown.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/tracker_models/sleep_model.dart';

class SleepTrackerProvider with ChangeNotifier {
  final List<SleepModel> _sleepData = [];
  List<SleepModel> get sleepData {
    return [..._sleepData];
  }

  Future<void> postSleepLogs(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}storeSleepLog';
    print("URL : $url");
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
        // log(responseData.toString());
        Fluttertoast.showToast(msg: 'Sleep Log stored successfully');
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> putSleepGoal(Map<String, dynamic> data, String userId) async {
    String url = '${ApiUrl.wm}put/user?id=$userId';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        // log(responseData.toString());
        Fluttertoast.showToast(msg: 'Sleep Goal saved successfully');
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  List<SleepModel> _allSleepData = [];
  List<SleepModel> get allSleepData {
    return [..._allSleepData];
  }

  Future<void> fetchSleepLogs(String data) async {
    String url = '${ApiUrl.wm}getSleepLogs?$data';
    log(url);
    List<SleepModel> loadedData = [];

    DateTime date = DateTime.now();

    List<String> dates = [];
    if (filterValue == filterOptions[0] || filterValue == null) {
      for (int i = 0; i < filterMap[filterOptions[0]]; i++) {
        dates.add(DateFormat("MM/dd/yyyy").format(date));
        date = date.subtract(
          const Duration(days: 1),
        );
      }
    }
    if (filterValue == filterOptions[1] || filterValue == null) {
      for (int i = 0; i < filterMap[filterOptions[1]]; i++) {
        dates.add(DateFormat("MM/dd/yyyy").format(date));
        date = date.subtract(
          const Duration(days: 1),
        );
      }
    }
    if (filterValue == filterOptions[2] || filterValue == null) {
      for (int i = 0; i < filterMap[filterOptions[2]]; i++) {
        dates.add(DateFormat("MM/dd/yyyy").format(date));
        date = date.subtract(
          const Duration(days: 1),
        );
      }
    }
    if (filterValue == filterOptions[3] || filterValue == null) {
      for (int i = 0; i < filterMap[filterOptions[3]]; i++) {
        dates.add(DateFormat("MM/dd/yyyy").format(date));
        date = date.subtract(
          const Duration(days: 1),
        );
      }
    }

    // log(dates.toString());
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
        final data = responseData["data"] as List<dynamic>;

        String todaysDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
        List previousWeek = [];

        DateTime startDate = DateFormat('dd/MM/yyyy').parse(todaysDate);

        if (filterValue == filterOptions[0]) {
          startDate = DateFormat('dd/MM/yyyy')
              .parse(todaysDate)
              .subtract(Duration(days: filterMap[filterOptions[0]]));
        }
        if (filterValue == filterOptions[1]) {
          startDate = DateFormat('dd/MM/yyyy')
              .parse(todaysDate)
              .subtract(Duration(days: filterMap[filterOptions[1]]));
        }
        if (filterValue == filterOptions[2]) {
          startDate = DateFormat('dd/MM/yyyy')
              .parse(todaysDate)
              .subtract(Duration(days: filterMap[filterOptions[2]]));
        }
        if (filterValue == filterOptions[3]) {
          startDate = DateFormat('dd/MM/yyyy')
              .parse(todaysDate)
              .subtract(Duration(days: filterMap[filterOptions[3]]));
        }

        // DateTime startDate = DateFormat('dd/MM/yyyy')
        //     .parse(todaysDate)
        //     .subtract(const Duration(days: 90));
        DateTime endDate = DateFormat('dd/MM/yyyy').parse(todaysDate);

        while (endDate.isAfter(startDate)) {
          startDate = startDate.add(
            const Duration(days: 1),
          );
          previousWeek.add(startDate);
        }

        List fdate = [];

        for (var dates in previousWeek) {
          var fDates = DateFormat('MM/dd/yyyy').format(dates);
          fdate.add(fDates);
        }
        // log(fdate.toString());
        // ignore: unused_local_variable
        int matchesFound = 0;

        for (var ele = 0; ele < fdate.length; ele++) {
          String? apiDate, apiDateInMs, fDateInMs;

          var fDateTime = DateFormat('MM/dd/yyyy').parse(fdate[ele]);
          fDateInMs = fDateTime.millisecondsSinceEpoch.toString();

          for (var i = 0; i < data.length; i++) {
            apiDate = data[i]["date"];

            var apiDateTime = DateFormat('MM/dd/yyyy').parse(apiDate!);
            apiDateInMs = apiDateTime.millisecondsSinceEpoch.toString();

            if (fdate[ele] == apiDate) {
              // log('match found');
              matchesFound += 1;
              loadedData.add(
                SleepModel(
                  date: apiDateInMs,
                  userId: data[i]["userId"],
                  sleepTime: data[i]["sleepTime"],
                  wakeupTime: data[i]["wakeupTime"],
                  sleepDurationInSeconds: data[i]["sleepDurationInSeconds"],
                  goal: data[i]["goalTime"],
                  id: data[i]["id"],
                ),
              );
              break;
            }
          }
          if (fdate[ele] != apiDate) {
            loadedData.add(
              SleepModel(
                date: fDateInMs,
                userId: "",
                sleepTime: "",
                wakeupTime: "",
                sleepDurationInSeconds: "0",
                goal: "0",
                id: "",
              ),
            );
            // log('matches found = $matchesFound');
          }
        }

        // for (var ele in data) {
        //   loadedData.add(
        //   SleepModel(
        //     date: ele["date"],
        //     userId: ele["userId"],
        //     sleepTime: ele["sleepTime"],
        //     wakeupTime: ele["wakeupTime"],
        //     sleepDurationInSeconds: ele["sleepDurationInSeconds"],
        //     goal: ele["goalTime"],
        //     id: ele["id"],
        //   ),
        // );
        // }

        // log(loadedData.toString());
        _allSleepData = loadedData;
        notifyListeners();
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
