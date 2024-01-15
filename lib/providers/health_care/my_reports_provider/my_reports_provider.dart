import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/health_care/my_reports/my_reports_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class MyLabReportsProvider with ChangeNotifier {
  Future<List<MyLabReports>> getMyLabReports(String userId) async {
    String url = "${ApiUrl.hc}get/labReport?userId=$userId";
    log(url);
    List<MyLabReports> loadedData = [];
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

        log(data.toString());

        for (var ele in data) {
          loadedData.add(
            MyLabReports(
              id: ele["_id"],
              labTestId: ele["labTestId"],
              v: ele["__v"],
              createdAt: DateTime.parse(ele["created_at"]),
              labId: ele["labId"],
              referredBy: ele["referredBy"],
              reportDate: DateTime.parse(ele["reportDate"]),
              reportTime: ele["reportTime"],
              tests: List<Test>.from(ele["tests"].map((x) => Test.fromJson(x))),
              updatedAt: DateTime.parse(ele["updated_at"]),
              userId: ele["userId"],
              labReportUrl: ele["labReportUrl"],
            ),
          );
        }

        log('fetched body measurements');
        return loadedData;
        // log(data.toString());
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
