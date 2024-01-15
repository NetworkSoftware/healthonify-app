import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:health/health.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/providers/trackers/heart_rate.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class StepTrackerData {
  bool? requested;
  String? stepCount;
  String? dist;
  double? percent;
  List<Map<String, dynamic>>? stepsData;

  StepTrackerData({
    this.requested,
    this.stepCount,
    this.dist,
    this.percent,
    this.stepsData,
  });
}

class StepTracker with ChangeNotifier {
  StepTrackerData stepTrackerData = StepTrackerData();

  // double getValue(double x, double y, double z) {
  //   double magnitude = sqrt(x * x + y * y + z * z);
  //   getPreviousValue();
  //   double modDistance = magnitude - previousDistacne;
  //   setPreviousValue(magnitude);
  //   return modDistance;
  // }
  //
  // void setPreviousValue(double distance) async {
  //   SharedPreferences _pref = await SharedPreferences.getInstance();
  //   _pref.setDouble("preValue", distance);
  // }
  //
  // void getPreviousValue() async {
  //   SharedPreferences _pref = await SharedPreferences.getInstance();
  //   setState(() {
  //     previousDistacne = _pref.getDouble("preValue") ?? 0.0;
  //   });
  // }

  Future<StepTrackerData> initHealth(int goal, DateTime startTime) async {
    bool requested = false;
    String stepCount = "0";
    String dist = "0";
    double percent = 0.0;
    SharedPrefManager prefManager = SharedPrefManager();
    List<Map<String, dynamic>> stepsData = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("goal $goal");
    log("start date for steps : ${startTime.toString()}");
    Stream<StepCount> stepCountStream;

    try {
      HealthFactory health = HealthFactory();
      PermissionStatus result = await Permission.activityRecognition.request();

      log("steps perm : $result");
      if (Platform.isIOS) {
        var types = [
          HealthDataType.STEPS
        ];

        var permissions = [
          HealthDataAccess.READ
        ];

        // requesting access to the data types before reading them
        requested = await health.requestAuthorization(types,permissions: permissions);

        if (requested) {
         // prefManager.saveStepTrackerEnabled(true);
          var distance =

              await health.getHealthDataFromTypes(startTime, DateTime.now(), [
                HealthDataType.STEPS,
          ]);
          double d = 0;
          for (var ele in distance) {
            d = d + double.parse(ele.value.toString());
            stepsData.add({
              "date": DateFormat("yyyy-MM-dd").format(ele.dateFrom),
              //"stepsCount": ele.value,
              "stepsCount": d,
              "time": DateFormat("hh:mm:ss").format(ele.dateFrom)
            });
          }
          int? steps =
              await health.getTotalStepsInInterval(startTime, DateTime.now());
          if (steps != null) {
            percent = steps / goal;
          }
          stepCount = steps.toString();
          log("step count $stepCount");
        }
      }

      if (result == PermissionStatus.granted) {

        if (Platform.isAndroid) {

          print("STEPCOUNT : ${kSharedPreferences.getInt('stepCount')}");
          stepsData.add({
            "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
            //"stepsCount": ele.value.toString(),
            "stepsCount":  kSharedPreferences.getInt('stepCount'),
            "overallStepCount":  kSharedPreferences.getInt("Step") ?? kSharedPreferences.getInt('overAllStepCount'),
            "time": DateFormat("hh:mm:ss").format(DateTime.now())
          });

          int steps =
          kSharedPreferences.getInt('stepCount')!;
          print("COUNT1111 : ${kSharedPreferences.getInt('stepCount')!}");
          percent = steps / goal;
                  stepCount = steps.toString();
          log("step count $stepCount");
          kSharedPreferences.remove("Step");

          // _stepCountStream = Pedometer.stepCountStream;
          // //_stepCountStream.listen(onStepCount).onError(onStepCountError);
          //
          // var types = [
          //   HealthDataType.STEPS,
          // ];
          //
          // var permissions = [
          //   HealthDataAccess.READ
          // ];
          //
          // if(kSharedPreferences.getBool("isGoogleRequest") == true){
          //   // requesting access to the data types before reading them
          //   requested = await health.requestAuthorization(types,permissions: permissions);
          //
          //   print("REQQQQQUEST12 : $requested");
          //   if (requested) {
          //     kSharedPreferences.setBool("isGoogleRequest", true);
          //     prefManager.saveStepTrackerEnabled(true);
          //     // DateTime testing = DateTime(2023, 5, 28);
          //     DateTime startDate = DateTime(
          //         DateTime.now().year, DateTime.now().month, DateTime.now().day);
          //     var distance =
          //     await health.getHealthDataFromTypes(startTime, DateTime.now(), [
          //       HealthDataType.STEPS,
          //     ]);
          //     // log("distance $distance");
          //     double d = 0;
          //     for (var ele in distance) {
          //       d = d + double.parse(ele.value.toString());
          //
          //     }
          //     int? steps =
          //     await health.getTotalStepsInInterval(startDate, DateTime.now());
          //     // log("steps " + steps.toString());
          //
          //     if (steps != null) {
          //       percent = steps / goal;
          //     }
          //     stepCount = steps.toString();
          //     log("step count $stepCount");
          //     // log("steps data $stepsData");
          //   }else{
          //     kSharedPreferences.setBool("isGoogleRequest", false);
          //   }
          // }
          // else if(kSharedPreferences.getBool("isGoogleRequest") == null){
          //   // requesting access to the data types before reading them
          //   requested = await health.requestAuthorization(types,permissions: permissions);
          //
          //   print("REQQQQQUEST12 : $requested");
          //   if (requested) {
          //     kSharedPreferences.setBool("isGoogleRequest", true);
          //     prefManager.saveStepTrackerEnabled(true);
          //     // DateTime testing = DateTime(2023, 5, 28);
          //     DateTime startDate = DateTime(
          //         DateTime.now().year, DateTime.now().month, DateTime.now().day);
          //     var distance =
          //     await health.getHealthDataFromTypes(startTime, DateTime.now(), [
          //       HealthDataType.STEPS,
          //     ]);
          //     // log("distance $distance");
          //     double d = 0;
          //     for (var ele in distance) {
          //       d = d + double.parse(ele.value.toString());
          //       stepsData.add({
          //         "date": DateFormat("yyyy-MM-dd").format(ele.dateFrom),
          //         //"stepsCount": ele.value.toString(),
          //         "stepsCount": d,
          //         "time": DateFormat("hh:mm:ss").format(ele.dateFrom)
          //       });
          //     }
          //     int? steps =
          //     await health.getTotalStepsInInterval(startDate, DateTime.now());
          //     // log("steps " + steps.toString());
          //
          //     if (steps != null) {
          //       percent = steps / goal;
          //     }
          //     stepCount = steps.toString();
          //     log("step count $stepCount");
          //     // log("steps data $stepsData");
          //   }else{
          //     kSharedPreferences.setBool("isGoogleRequest", false);
          //   }
          // }

          // d = d.round();
          // dist = d.toString();
        }
      }

      StepTrackerData data = StepTrackerData();
      data.requested = requested;
      data.stepCount = stepCount;
      data.dist = dist;
      data.percent = percent;
      data.stepsData = stepsData;

      stepTrackerData = data;
      notifyListeners();
      return data;
    } catch (e) {
      log("unable to get step count $e");
      Fluttertoast.showToast(msg: "Unable to get step count");
      rethrow;
    }
  }

  Future<void> updateStepsTrackerGoal(String goal, String userId) async {
    String url = '${ApiUrl.wm}put/user?id=$userId';
    log(url);
    log("goal $goal");
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "set": {"dailyStepCountGoal": goal}
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

  Future<void> updateSteps(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}storeStepCount';
    log("steps update url $url");
    log("steps update data ${json.encode(data)}");

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

class HeartRateTracker with ChangeNotifier {
  Future<List<HeartRateData>> initHeart() async {
    log("init heart");
    HealthFactory health = HealthFactory();
    PermissionStatus result = await Permission.activityRecognition.request();
    bool requested = false;
    List<HeartRateData> data = [];

    if (Platform.isIOS) {
      var types = [
        HealthDataType.HEART_RATE,
      ];
      // requesting access to the data types before reading them
      requested = await health.requestAuthorization(types);
      var now = DateTime.now();
      if (requested) {
        // prefManager.saveStepTrackerEnabled(true);
        var midnight = DateTime(now.year, now.month, now.day);
        var heartRateLogs =
            await health.getHealthDataFromTypes(midnight, DateTime.now(), [
          HealthDataType.HEART_RATE,
        ]);

        data = List.generate(
          heartRateLogs.length,
          (index) => HeartRateData(
              value:
                  (double.parse(heartRateLogs[index].value.toString())).round(),
              time:
                  "${heartRateLogs[index].dateFrom.hour}:${heartRateLogs[index].dateFrom.minute}",
              platform: heartRateLogs[index].platform == PlatformType.IOS
                  ? "iOS"
                  : "Android"),
        );
      }
    }

    if (result == PermissionStatus.granted) {
      if (Platform.isAndroid) {
        var types = [
          HealthDataType.HEART_RATE,
        ];
        // requesting access to the data types before reading them
      //  requested = await health.requestAuthorization(types);
        var now = DateTime.now();

        if (requested) {
          // prefManager.saveStepTrackerEnabled(true);
          var midnight = DateTime(now.year, now.month, now.day);
          var heartRateLogs =
              await health.getHealthDataFromTypes(midnight, DateTime.now(), [
            HealthDataType.HEART_RATE,
          ]);

          data = List.generate(
            heartRateLogs.length,
            (index) => HeartRateData(
                value: (double.parse(heartRateLogs[index].value.toString()))
                    .round(),
                time:
                    "${heartRateLogs[index].dateFrom.hour}:${heartRateLogs[index].dateFrom.minute}",
                platform: heartRateLogs[index].platform == PlatformType.IOS
                    ? "iOS"
                    : "Android"),
          );
        }
      }
    }

    return data;
  }
}
