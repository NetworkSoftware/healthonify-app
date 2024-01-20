import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/notifications.dart';
import 'package:http/http.dart' as http;

class NotificationsData with ChangeNotifier {
  List<Notifications> _notificationData = [];

  List<Notifications> get notificationData {
    return [..._notificationData];
  }

  Future<void> getNotifications(String userId) async {
    String url = "${ApiUrl.url}get/notification?userId=$userId";
    List<Notifications> loadedData = [];

    log("notifications url $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      // log(json.encode(responseData));
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        final data = responseData['data'] as List<dynamic>;
        // log(data.toString());

        for (var element in data) {
          loadedData.add(
            Notifications(
              body: element["body"],
              id: element["_id"],
              title: element["title"],
              userId: element["userId"],
              createdAt: element["created_at"],
            ),
          );
        }

        _notificationData = loadedData;

        // log(_userData.roles![0]["address"].toString());
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
