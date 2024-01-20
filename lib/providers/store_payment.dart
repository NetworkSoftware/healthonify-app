import 'dart:convert';
import 'dart:developer';

import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class StorePayment {
  static Future<void> storePayment(Map data, String from) async {
    String url;

    if (from == "diet") {
      url = "${ApiUrl.wm}wm/payment/store";
    } else {
      url = "${ApiUrl.url}payment/store";
    }
    log(url);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      log(response.body.toString());
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData =
            json.decode(response.body)["data"] as Map<String, dynamic>;

        log(responseData.toString());

        // notifyListeners();
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> storeLabBookingPayment(Map data) async {
    String url;
    url = '${ApiUrl.hc}labs/payment/store';

    log(url);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      log(response.body.toString());
      final responseMessage = json.decode(response.body);
      if (response.statusCode >= 400) {
        throw HttpException(responseMessage["message"]);
      }
      if (responseMessage["status"] == 1) {
        final responseData =
            json.decode(response.body)["data"] as Map<String, dynamic>;

        log(responseData.toString());
      } else {
        throw HttpException(responseMessage["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
