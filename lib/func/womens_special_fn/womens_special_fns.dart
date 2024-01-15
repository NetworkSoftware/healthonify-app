import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/womens_special/womens_special_provider.dart';
import 'package:provider/provider.dart';

class WomensSpecialFun {
  Future<void> fetchFlowIntensity(BuildContext context) async {
    try {
      await Provider.of<WomensSpecialProvider>(context, listen: false)
          .getFlowIntensity();
      log("Flow Intensity fetched");
    } on HttpException catch (e) {
      log('Error fetching Flow Intensity data http $e');
      // Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log('Error fetching Flow Intensity data $e');
      // Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  Future<void> fetchSymptoms(BuildContext context) async {
    try {
      await Provider.of<WomensSpecialProvider>(context, listen: false)
          .getWcSymptoms();
      log("Symptoms fetched");
    } on HttpException catch (e) {
      log('Error fetching Symptoms data http $e');
      // Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log('Error fetching Symptoms data $e');
      // Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  Future<void> fetchMoods(BuildContext context) async {
    try {
      await Provider.of<WomensSpecialProvider>(context, listen: false)
          .getWcMoods();
      log("Flow Symptoms fetched");
    } on HttpException catch (e) {
      log('Error fetching moods data http $e');
      // Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log('Error fetching moods data $e');
      // Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  Future<void> postPeriods(
      BuildContext context, Map<String, dynamic> data) async {
    try {
      await Provider.of<WomensSpecialProvider>(context, listen: false)
          .postPeriodLogs(data);
      print(data);
      log("posted periods");
      Fluttertoast.showToast(msg: "Flow Stored");
    } on HttpException catch (e) {
      log('Error posting periods data http $e');
      // Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log('Error posting periods data $e');
      // Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  Future<void> fetchPeriods(BuildContext context,
      {required String userId, String date = ""}) async {
    String params;
    if (date.isNotEmpty) {
      params = "userId=$userId&menustralDate=$date";
    } else {
      params = "userId=$userId";
    }

    try {
      await Provider.of<WomensSpecialProvider>(context, listen: false)
          .getPeriods(params);
      log(params);
      log("periods fetched");
    } on HttpException catch (e) {
      log('Error fetching periods data http $e');
      // Fluttertoast.showToast(msg: "Something went wrong");
    } catch (e) {
      log('Error fetching periods data $e');
      // Fluttertoast.showToast(msg: "Something went wrong");
    }
  }
}
