import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/widgets/drop_downs/filter_dropdown.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/tracker_models/water_intake_model.dart';

class WaterIntakeProvider with ChangeNotifier {
  List<WaterIntake> _waterData = [];
  List<WaterIntake> get waterData {
    return [..._waterData];
  }

  Future<void> getWaterIntake(String id, String date) async {
    String url = "${ApiUrl.wm}get/waterIntake/?userId=$id&date=$date";
    List<WaterIntake> loadedData = [];

    // log(url);

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
        final data = json.decode(response.body)['data'] as List<dynamic>;
        for (var ele in data) {
          loadedData.add(
            WaterIntake(
              id: ele['userId'],
              date: ele['date'],
              waterGlass: ele['waterGlass'].toString(),
              goalCount: ele["goalCount"],
            ),
          );
        }

        _waterData = loadedData;
        log('fetched water intake');
        notifyListeners();
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  List<WaterIntake> _allWaterData = [];
  List<WaterIntake> get allWaterData {
    return [..._allWaterData];
  }

  Future<List<WaterIntake>> getAllWaterIntakeData(String data) async {
    String url = "${ApiUrl.wm}get/waterIntake/?$data";
    List<WaterIntake> loadedData = [];

    log("get water intake $url");
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
        final data = json.decode(response.body)['data'] as List<dynamic>;

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
                WaterIntake(
                  id: data[i]["userId"],
                  date: apiDateInMs,
                  waterGlass: data[i]["waterGlass"].toString(),
                  goalCount: data[i]["goalCount"],
                ),
              );
              break;
            }
          }
          if (fdate[ele] != apiDate) {
            loadedData.add(
              WaterIntake(
                id: "",
                date: fDateInMs,
                waterGlass: "0",
                goalCount: "0",
              ),
            );
            // log('matches found = $matchesFound');
          }
        }
        _allWaterData = loadedData;

        // log('fetched all water intake');
        return _allWaterData;
        // notifyListeners();
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> postWaterIntake(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}addOrRemoveWaterGlass';
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
        log(responseData.toString());
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateWaterTrackerGoal(String goal, String userId) async {
    String url = '${ApiUrl.wm}put/user?id=$userId';
    // log(url);
    // log("goal $goal");
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "set": {"dailyWaterGoal": goal}
        }),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        log(responseData.toString());
        // _waterData[0].goalCount = goal;
        // notifyListeners();
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
