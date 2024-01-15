import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/womens_special_models/ws_flow_intensity_model.dart';
import 'package:healthonify_mobile/models/womens_special_models/ws_periods_model.dart';
import 'package:http/http.dart' as http;

class WomensSpecialProvider with ChangeNotifier {
  List<WSLogModel> _flowIntensity = [];
  List<WSLogModel> get flowIntensity {
    return [..._flowIntensity];
  }

  List<WSLogModel> _symptoms = [];
  List<WSLogModel> get symptoms {
    return [..._symptoms];
  }

  List<WSLogModel> _moods = [];
  List<WSLogModel> get moods {
    return [..._moods];
  }

  List<PeriodLogsModel> _periodLogs = [];
  List<PeriodLogsModel> get periodLogs {
    return [..._periodLogs];
  }

  Future<void> getFlowIntensity() async {
    String url = '${ApiUrl.hc}get/wcFlowIntensity';

    List<WSLogModel> loadedData = [];

    log("flow intensity $url");

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
        var data = responseData["data"] as List<dynamic>;
        for (var element in data) {
          loadedData.add(
            WSLogModel.fromJson(element),
          );
        }
        _flowIntensity = loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getWcSymptoms() async {
    String url = '${ApiUrl.hc}get/wcSymptoms';

    List<WSLogModel> loadedData = [];

    log("symptomps $url");

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
        var data = responseData["data"] as List<dynamic>;
        for (var element in data) {
          loadedData.add(
            WSLogModel.fromJson(element),
          );
        }
        _symptoms = loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getWcMoods() async {
    String url = '${ApiUrl.hc}get/wcMood';

    List<WSLogModel> loadedData = [];

    log("moods $url");

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
        var data = responseData["data"] as List<dynamic>;
        for (var element in data) {
          loadedData.add(
            WSLogModel.fromJson(element),
          );
        }
        _moods = loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postPeriodLogs(Map<String, dynamic> data) async {
    String url = '${ApiUrl.hc}post/wcPeriodLogs';
    log("post period $url");

    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode(data));
      log(json.encode(data));
      final responseData = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData['status'] == 1) {
        var data = responseData["data"];
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getPeriods(String params) async {
    String url = '${ApiUrl.hc}get/wcPeriodLogs?$params';

    List<PeriodLogsModel> loadedData = [];

    log("moods $url");

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
        var data = responseData["data"] as List<dynamic>;
        for (var element in data) {
          loadedData.add(
            PeriodLogsModel.fromJson(element),
          );
        }
        _periodLogs = loadedData;
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
