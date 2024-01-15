import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/tracker_models/water_intake_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/trackers/water_intake.dart';
import 'package:provider/provider.dart';

class WaterTracker {
  Future<void> getWaterData(BuildContext context) async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    String? currentDate = DateFormat('MM/dd/yyyy').format(DateTime.now());

    // log(DateTime.now().toString());
    try {
      await Provider.of<WaterIntakeProvider>(context, listen: false)
          .getWaterIntake(userId!, currentDate);
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error get get top level expertise widget $e");
      Fluttertoast.showToast(msg: "Unable to fetch water intake data");
    }
  }

  Future<List<WaterIntake>> getAllWaterData(BuildContext context) async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      List<WaterIntake> data =
          await Provider.of<WaterIntakeProvider>(context, listen: false)
              .getAllWaterIntakeData("userId=$userId");

      return data;
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
      rethrow;
    } catch (e) {
      log("Error get get top level expertise widget $e");
      Fluttertoast.showToast(msg: "Unable to fetch water intake data");
      rethrow;
    }
  }

  Future<void> updateWaterGoal(
      BuildContext context, String goal, VoidCallback onSucess) async {
    String? userId = Provider.of<UserData>(context, listen: false).userData.id;
    try {
      await Provider.of<WaterIntakeProvider>(context, listen: false)
          .updateWaterTrackerGoal(goal, userId!);
      onSucess.call();
    } on HttpException catch (e) {
      log(e.toString());
      // Fluttertoast.showToast(msg: e.message);
      Fluttertoast.showToast(msg: "Unable to update water goal");
    } catch (e) {
      log("Error get get top level expertise widget $e");
      Fluttertoast.showToast(msg: "Unable to update water goal");
    }
  }
}
