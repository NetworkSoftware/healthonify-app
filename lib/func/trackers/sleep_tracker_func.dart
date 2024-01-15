import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/trackers/sleep_tracker.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:provider/provider.dart';

class SleepTrackerFunc {
  String toDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String fromDate = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().subtract(const Duration(days: 31)));

  Future<void> getSleepLogs(BuildContext context) async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      await Provider.of<SleepTrackerProvider>(context, listen: false)
          .fetchSleepLogs("userId=$userId&toDate=$toDate&fromDate=$fromDate");

      log('fetched monthly sleep logs');
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get get top level expertise widget $e");
      // Fluttertoast.showToast(msg: "Unable to fetch water intake data");
    }
  }

  Future<void> getAllSleepLogs(BuildContext context) async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;

    try {
      await Provider.of<SleepTrackerProvider>(context, listen: false)
          .fetchSleepLogs("userId=$userId");
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: 'No data found');
    } catch (e) {
      log("Error getting sleep chart widget $e");
      // Fluttertoast.showToast(msg: "Unable to fetch water intake data");
    }
  }
}
