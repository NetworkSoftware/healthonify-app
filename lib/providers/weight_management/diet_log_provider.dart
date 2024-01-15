import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/diet_log_model.dart';
import 'package:http/http.dart' as http;

class DietLogProvider with ChangeNotifier {
  List<DietLog> _dietLog = [];
  List<DietLog> get dietLog {
    return [..._dietLog];
  }

  Future<void> getDietLogs({String? userId, String? date}) async {
    String url = '${ApiUrl.wm}get/dietConsumption?userId=$userId&date=$date';

    log("get diet log url $url");
    List<DietLog> loadedData = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = responseData['data'] as List<dynamic>;

        for (var ele in data) {
          loadedData.add(DietLog.fromJson(ele));
        }
        // log(data.toString());
        _dietLog = loadedData;
        notifyListeners();
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postDietPlan(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}post/dietConsumption';

    log("post diet log url $url");

    log("DATA : $data");

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
      if (responseData['status'] == 1) {
        // final data = responseData['data'] as List<dynamic>;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
