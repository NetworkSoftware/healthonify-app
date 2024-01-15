import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/experts/upcoming_sessions.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/physiotherapy/consultation_session.dart';
import 'package:http/http.dart' as http;

class SessionData with ChangeNotifier {
  final ConsultationSession _consultationSession = ConsultationSession();
  ConsultationSession get consultationSession {
    return _consultationSession;
  }

  Future<void> submitConsultNowForm(Map<String, dynamic> data) async {
    String url = "${ApiUrl.url}update/paidConsultationSession";

    // print(requestData);

    log(data.toString());
    log(url.toString());
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      // log(responseData.toString());

      if (response.statusCode >= 400) {
        log(responseData["error"].toString());
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        final payData = json.decode(response.body)["data"][0]["Result"];
        _consultationSession.id = payData["_id"];
        _consultationSession.galleryIds =
            List<dynamic>.from(payData["galleryIds"].map((x) => x));
        _consultationSession.subscriptionId = payData["subscriptionId"];
        _consultationSession.order = payData["order"];
        _consultationSession.status = payData["status"];
        _consultationSession.startDate = payData["startDate"];
        _consultationSession.startTime = payData["startTime"];
        _consultationSession.startTimeMiliseconds =
            payData["startTimeMiliseconds"];
        _consultationSession.specialExpertId = payData["specialExpertId"];
        _consultationSession.videoCallLink = payData["videoCallLink"];

        log(_consultationSession.galleryIds.toString());

        log(payData.toString());
        // log(_paymentData.rzpOrderId!);
      } else {
        log(responseData["error"].toString());
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  List<Session> _session = [];
  List<Session> get session {
    return [..._session];
  }

  Future<bool> getAllSessions({required String data}) async {
    _session.clear();
    String url = "${ApiUrl.url}get/session$data";
    List<Session> loadedData = [];

    log("get all sessions $url");

    log(url.toString());
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
       log(responseData.toString());

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

  final List<Session> _wmsession = [];
  List<Session> get wmsession {
    return [..._wmsession];
  }

  Future<bool> getAllWmSessions(String subId) async {
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

  Future<void> updateSession(Map<String, dynamic> data, String flow) async {
    String url;
    if (flow == "Dietitian") {
      url = "${ApiUrl.wm}wm/update/paidConsultationSession";
    } else {
      url = "${ApiUrl.url}update/paidConsultationSession";
    }
    // List<Session> _loadedData = [];
    log(url);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      // log(responseData.toString());

      if (response.statusCode >= 400) {
        log(responseData["error"].toString());
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        // final payData = json.decode(response.body)["data"] as List<dynamic>;
        log(responseData.toString());

        for (var element in _upcomingSessions) {
          log("hey");
          if (element.id == data["sessionId"]) {
            element.status = "sessionEnded";
          }
        }

        // for (var element in _loadedData) {
        //   log(element.toString());
        // }
        notifyListeners();
      } else {
        log(responseData["error"].toString());
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  List<UpcomingSessions> _upcomingSessions = [];
  List<UpcomingSessions> get upcomingSessions {
    return _upcomingSessions;
  }

  Future<void> fetchUpcommingSessions(String data, String flow) async {
    _upcomingSessions.clear();
    String url;

    if (flow == "Dietitian") {
      url = "${ApiUrl.wm}wm/fetch/upcomingWmSessions?$data";
    } else if (flow == "Health Care") {
      url = "${ApiUrl.hc}wm/fetch/upcomingWmSessions?$data";
    } else {
      url = "${ApiUrl.url}fetch/upcomingSessions?$data";
    }
    List<UpcomingSessions> loadedData = [];
    // print(requestData);

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
        for (var element in payData) {
          loadedData.add(
            UpcomingSessions(
              name: element["name"] ?? "",
              benefits: element["benefits"] ?? "",
              description: element["description"] ?? "",
              durationInMinutes: element["durationInMinutes"] ?? "",
              subscription: element["subscriptionId"] ?? {},
              id: element["_id"] ?? "",
              startTime: element["startTime"] ?? "",
              startDate: element["startDate"] ?? "",
              order: element["order"] ?? "",
              startTimeMiliseconds: element["startTimeMiliseconds"] ?? "",
              status: element["status"] ?? "",
              videoCallLink: element["videoCallLink"] ?? "",
              specialExpertId: element["specialExpertId"] ?? "",
              clientName: element["clientName"] ?? "",
              expertName: element['expertName'] ?? "",
              packageName: element['packageName'] ?? "",
              consultation: element["subscriptionId"] != null
                  ? element["subscriptionId"]["consultationId"]
                  : {},
            ),
          );
        }

        log(loadedData[0].order.toString());
        _upcomingSessions = loadedData;
      } else {
        log(responseData["error"].toString());
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      _upcomingSessions.clear();
      rethrow;
    }
  }

  Future<void> storeSession(Map<String, dynamic> data) async {
    String url = "${ApiUrl.url}store/session";

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
