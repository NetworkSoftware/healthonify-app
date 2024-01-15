import 'dart:convert';
import 'dart:developer';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/vitals/all_vitals.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HbA1cData with ChangeNotifier {
  Future<HbA1c> getHba1cData(String userId, String dateType) async {
    String url =
        "${ApiUrl.wm}fetchLogs/userHba1c?userId=$userId&dateType=$dateType";

    HbA1c hbA1cData = HbA1c();

    log(url);
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
        final data = json.decode(response.body)['data'] as Map<String, dynamic>;
        hbA1cData.averageData = data["averageData"];
        hbA1cData.recentLogs = (data["recentLogs"] as List<dynamic>)
            .map(
              (item) => Hba1CRecentLogs(
                  id: item["_id"],
                  date: item["date"],
                  userId: item["userId"],
                  hba1cLevel: item["hba1cLevel"],
                  time: item["time"]),
            )
            .toList();

        log(hbA1cData.averageData.toString());

        // log(data.toString());
        log('fetched hba1c');
        return hbA1cData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> storeHba1cData(Map<String, String> data) async {
    String url = "${ApiUrl.wm}store/hba1cLogs";

    log(url);
    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> editHba1cData(Map<String, dynamic> data, String hba1cId) async {
    String url = "${ApiUrl.wm}put/userHba1c?id=$hba1cId";

    log(url);
    try {
      final response = await http.put(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      final responseData = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
