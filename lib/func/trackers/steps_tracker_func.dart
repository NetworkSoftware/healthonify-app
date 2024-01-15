import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/func/trackers/step_tracker.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:provider/provider.dart';

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
      Fluttertoast.showToast(msg: "Unable to update steps ");
    } catch (e) {
      log("Error step tracker func update steps $e");
      Fluttertoast.showToast(msg: "Unable to update steps ");
    }
  }
}
