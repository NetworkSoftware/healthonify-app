import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class FitnessToolsData with ChangeNotifier {
  Future<Map<String, dynamic>> calculateTool(String data) async {
    String url = "${ApiUrl.wm}calculate/fitness?$data";
    log("fitness tools url $url");
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData =
            json.decode(response.body)["data"] as Map<String, dynamic>;

        log("Fetched fitness data");

        return (responseData);

        // notifyListeners();
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future setMealTargets(Map<String, dynamic> data, String userId) async {
    String url = '${ApiUrl.wm}put/user?id=$userId';

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
