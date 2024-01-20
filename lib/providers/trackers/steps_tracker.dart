import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/tracker_models/steps_model.dart';
import 'package:healthonify_mobile/widgets/drop_downs/filter_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class StepTrackerProvider with ChangeNotifier {
  List<StepsModel> _stepsData = [];
  List<StepsModel> get stepsData {
    return [..._stepsData];
  }

  List<StepCounter> _stepsLastData = [];
  List<StepCounter> get stepsLastData {
    return [..._stepsLastData];
  }

  Future<String> getStepsCount(String userId) async {
    String toDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String fromDate = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 31)));

    String url =
        '${ApiUrl.wm}getStepsCount?userId=$userId&toDate=$toDate&fromDate=$fromDate';

    log("getStepsCount url $url");

    List<StepsModel> loadedData = [];

    DateTime date = DateTime.now();

    List<String> dates = [];
    for (int i = 0; i < 90; i++) {
      dates.add(DateFormat("MM/dd/yyyy").format(date));
      date = date.subtract(
        const Duration(days: 1),
      );
    }

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
        final data = responseData["data"]["totalData"] as List<dynamic>;

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
        // ignore: unused_local_variable
        int matchesFound = 0;

        for (var ele = 0; ele < fdate.length; ele++) {
          String? apiDate, apiDateInMs, fDateInMs, formattedApiDate;

          var fDateTime = DateFormat('MM/dd/yyyy').parse(fdate[ele]);
          fDateInMs = fDateTime.millisecondsSinceEpoch.toString();

          for (var i = 0; i < data.length; i++) {
            apiDate = data[i]["date"];

            var apiDateTime = DateFormat('yyyy-MM-dd').parse(apiDate!);

            formattedApiDate = DateFormat('MM/dd/yyyy').format(apiDateTime);

            apiDateInMs = apiDateTime.millisecondsSinceEpoch.toString();

            // log('${fdate[ele]} x $apiDate');

            log("Ff : $formattedApiDate");
            log("Ff1 : ${fdate[ele]}");
            if (fdate[ele] == formattedApiDate) {
              matchesFound += 1;
              loadedData.add(
                StepsModel(
                  date: apiDateInMs,
                  userId: data[i]["userId"],
                  stepsCount: data[i]["stepsCount"],
                  goalCount: data[i]["goalCount"],
                ),
              );
              break;
            }
          }
          if (fdate[ele] != formattedApiDate) {
            loadedData.add(
              StepsModel(
                date: fDateInMs,
                userId: "",
                stepsCount: 0,
                goalCount: 0,
              ),
            );
          }
        }

        _stepsData = loadedData;
        var latestDateFormatted =
            DateFormat("MM/dd/yyyy").format(DateTime.now());
        if (data.isNotEmpty) {
          var latestDate = DateFormat('yyyy-MM-dd').parse(data.first["date"]);
          latestDateFormatted = DateFormat('MM/dd/yyyy').format(latestDate);
        }
        notifyListeners();
        return latestDateFormatted;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StepCounter>> getLastStepsCounter(String userId) async {
    String fromDate = DateFormat('MM/dd/yyyy').format(DateTime.now());

    String url =
        '${ApiUrl.wm}get/stepCounter?userId=$userId&fromDate=$fromDate';

    log("stepCounter url $url");

    List<StepCounter> loadedData = [];

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

        for (var i = 0; i < data.length; i++) {
          loadedData.add(
            StepCounter(
              date: data[i]["date"],
              userId: data[i]["userId"],
              stepCount: data[i]["stepsCount"],
              goalCount: data[i]["goalCount"],
              id: data[i]["_id"],
              time: data[i]["time"],
              overallStepCounter: data[i]["overallStepCounter"],
            ),
          );
        }
        String lastStepCount;
        _stepsLastData = loadedData;
        notifyListeners();

        return loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
