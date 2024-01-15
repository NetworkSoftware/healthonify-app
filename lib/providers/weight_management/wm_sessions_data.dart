import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/physiotherapy/consultation_session.dart';
import 'package:http/http.dart' as http;

class WmSessionsData with ChangeNotifier {
  List<Session> _session = [];
  List<Session> get session {
    return [..._session];
  }

  Future<bool> getAllSessions(String subId) async {
    _session.clear();
    String url = "${ApiUrl.wm}get/wmSession?subscriptionId=$subId";
    List<Session> loadedData = [];

    log(subId);

    log(url.toString());
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      // log(responseData.toString());

      if (response.statusCode >= 400) {
        log(responseData["error"].toString());
        throw HttpException(responseData["message"]);
      }

      if (responseData["status"] == 1) {
        final payData = json.decode(response.body)["data"] as List<dynamic>;
        // log(payData.toString());
        if (payData.isEmpty) {
          return false;
        }
        for (var element in payData) {
          loadedData.add(
            Session(data: element as Map<String, dynamic>),
          );
        }
        _session = loadedData;
        log(loadedData[0].data.toString());
        return true;
      } else {
        log(responseData["error"].toString());
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      _session.clear();
      rethrow;
    } finally {}
  }

  Future<void> storeSession(Map<String, dynamic> data) async {
    String url = "${ApiUrl.wm}wm/store/session";

    // log(url.toString());

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      log(responseData.toString());
      log(response.statusCode.toString());

      if (response.statusCode >= 400) {
        log(responseData["error"].toString().toString());
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        // final payData = json.decode(response.body)["data"] as List<dynamic>;
        // log(payData.toString());
      } else {
        log(responseData["error"].toString().toString());
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }


}
