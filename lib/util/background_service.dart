// import 'dart:async';
//
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:healthonify_mobile/main.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// /// Initializing background services
// Future<void> initializeBackgroundService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//     iosConfiguration: IosConfiguration(
//       onForeground: _onStart,
//       onBackground: onIosBackground,
//     ),
//     androidConfiguration: AndroidConfiguration(
//       onStart: _onStart,
//       autoStart: true,
//       isForegroundMode: true,
//       initialNotificationContent: "Running",
//       initialNotificationTitle: "Healthonify",
//     ),
//   );
// }
//
// void _onStart(ServiceInstance service) {
//   Timer? timer;
//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) async {
//       await service.setAsForegroundService();
//     });
//
//     service.on('setAsBackground').listen((event) async {
//       await service.setAsBackgroundService();
//       var now = DateTime.now();
//       AndroidAlarmManager.oneShotAt(DateTime(now.year,now.month,now.day,12,29), 1, fireAlarm);
//     });
//
//   }
//
//   service.on('stopService').listen((event) async {
//     await service.stopSelf();
//   });
//
//   service.on("startTimer").listen((event) async{
//     final sharedPref = await SharedPreferences.getInstance();
//   });
//
// }
//
//
// // to ensure this executed
// // run app from xcode, then from xcode menu, select Simulate Background Fetch
// bool onIosBackground(ServiceInstance service) {
//   WidgetsFlutterBinding.ensureInitialized();
//   return true;
// }
