import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/func/trackers/step_tracker.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class StepsTrackerFunc {
  Future<void> updateStepsGoal(
      BuildContext context, String goal, VoidCallback onSucess) async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      await Provider.of<StepTracker>(context, listen: false)
          .updateStepsTrackerGoal(goal, userId!);
      onSucess.call();
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToas8t(msg: e.message);
      Fluttertoast.showToast(msg: "Unable to update steps goal");
    } catch (e) {
      log("Error steps tracker update steps goal $e");
      Fluttertoast.showToast(msg: "Unable to update steps goal");
    }
  }

  Future<void> updateSteps(BuildContext context,
      List<Map<String, dynamic>> stepsData, VoidCallback onSuccess) async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      await Provider.of<StepTracker>(context, listen: false).updateSteps({
        "userId": userId,
        // "date": DateFormat("yyyy-MM-dd")
        //     .format(DateTime.now()), //The date should be "yyyy-mm-dd" only
        "stepsData": stepsData
      });
      log("updated steps");
      onSuccess.call();
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToas8t(msg: e.message);
      // Fluttertoast.showToast(msg: "Unable to update steps\n$e.toString()");
    } catch (e) {
      log("Error step tracker func update steps $e");
      // Fluttertoast.showToast(msg: "Unable to update steps $e");
    }
  }

  Future<void> updateStepsService(
      List<Map<String, dynamic>> stepsData, String userId) async {
    String url = '${ApiUrl.wm}storeStepCount';

    dynamic data = {
      "userId": '659ce3511863e95748dfbc5d',
      "stepsData": stepsData
    };
    debugPrint("storeStepCount-result==${data.toString()}");
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      debugPrint("storeStepCount-result==updateStepsService");
      debugPrint(responseData.toString());
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        debugPrint(responseData.toString());
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
