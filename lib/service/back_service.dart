import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:healthonify_mobile/func/trackers/step_tracker.dart';
import 'package:healthonify_mobile/func/trackers/steps_tracker_func.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
      iosConfiguration: IosConfiguration(
          autoStart: true,
          onForeground: onStart,
          onBackground: onIosBackground),
      androidConfiguration: AndroidConfiguration(
          onStart: onStart, isForegroundMode: true, autoStart: true));
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    DartPluginRegistrant.ensureInitialized();
    var stepCountStream = Pedometer.stepCountStream;
    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });
      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });
      service.on('stopService').listen((event) {
        service.stopSelf();
      });
      Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (await service.isForegroundService()) {
          void onStepCountError(error) {}

          void onStepCount(StepCount event) async {
            debugPrint("SSSSS==TODAY_CC=======${event.steps}");
            debugPrint("SSSSS==TODAY_CC=======${event.steps}");
            var startTime = DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 0, 0, 0);
            var currentTime = DateTime.now();
            var diff = currentTime.difference(startTime).inMinutes;
            try {
              if (!preferences.containsKey("totalCountVal") ||
                  !preferences.containsKey('updateDate') ||
                  preferences.getInt("totalCountVal") == null ||
                  preferences.getInt("todayCountVal") == null ||
                  preferences.getInt("totalCountVal") == 0) {
                preferences.setInt("totalCountVal", event.steps);
                preferences.setString("updateDate",
                    DateFormat("MM/dd/yyyy").format(DateTime.now()));
                debugPrint(
                    "SSSSS==TODAY_CC=======${event.steps - (preferences.getInt("totalCountVal") ?? 0)}");
                preferences.setInt("todayCountVal",
                    (event.steps - (preferences.getInt("totalCountVal") ?? 0)));
              } else {
                if (((preferences.getString('updateDate').toString() !=
                            DateFormat("MM/dd/yyyy").format(DateTime.now())) ||
                        (diff > 0 && diff < 10)) &&
                    preferences.getInt("todayCountVal").toString() != "0") {
                  StepTrackerData stepsData = StepTrackerData();
                  stepsData.stepCount =
                      (event.steps - (preferences.getInt("totalCountVal") ?? 0))
                          .toString();
                  stepsData.stepsData = [
                    {
                      "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                      "stepsCount": (event.steps -
                              (preferences.getInt("totalCountVal") ?? 0))
                          .toString(),
                      "overallStepCount": event.steps.toString(),
                      "time": DateFormat("hh:mm:ss").format(DateTime.now())
                    }
                  ];
                  await StepsTrackerFunc().updateStepsService(
                      stepsData.stepsData!, SharedPrefManager().userId);
                  preferences.setInt("todayCountVal", 0);
                  preferences.setInt("totalCountVal", event.steps);
                  preferences.setString("updateDate",
                      DateFormat("MM/dd/yyyy").format(DateTime.now()));
                } else {
                  preferences.setInt(
                      "todayCountVal",
                      (event.steps -
                          (preferences.getInt("totalCountVal") ?? 0)));
                  preferences.setString("updateDate",
                      DateFormat("MM/dd/yyyy").format(DateTime.now()));
                }
              }
            } catch (e) {
              //
            }
          }

          stepCountStream = Pedometer.stepCountStream;
          stepCountStream.listen(onStepCount).onError(onStepCountError);
          service.invoke('update');
        } else {
          //
        }
      });
    }
  } catch (e) {
    //
  }
}
