import 'dart:convert';
import 'dart:developer';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/tracker_models/weight_log.dart';

class WeightLogs with ChangeNotifier {
  List<WeightLog> _weightlogs = [];

  List<WeightLog> get weightlogs {
    return [..._weightlogs];
  }

  Future<void> getWeightLogs(String userId) async {
    String url = "${ApiUrl.wm}get/weightLog?userId=$userId";
    List<WeightLog> loadedData = [];
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body);
      // log(responseData.toString());
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        final data = json.decode(response.body)['data'] as List<dynamic>;

        for (var ele in data) {
          loadedData.add(
            WeightLog(
              id: ele['_id'],
              weight: ele['weight'] != null ? ele['weight'].toDouble() : 0.0,
              date: ele['date'],
            ),
          );
        }

        _weightlogs = loadedData;
        // log(data.toString());
        log('fetched weight logs');
        notifyListeners();
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> postWeightLogs(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}store/weightLog';

    log(data.toString());

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      log(responseData.toString());

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        log(responseData.toString());
        log(responseData['message']);
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future updateWeightLogs(
      String weightLogId, Map<String, dynamic> data, String userId) async {
    String url = '${ApiUrl.wm}put/weightLog?id=$weightLogId&userId=$userId';

    log(data.toString());

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        log('response data = $responseData');
        log(responseData['message']);
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
