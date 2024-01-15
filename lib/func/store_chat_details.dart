import 'dart:convert';
import 'dart:developer';

import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class StoreChatDetails {
  static Future<void> storeChatDetails(Map<String, String> data) async {
    String url = "${ApiUrl.url}chat/saveChatDetails";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      log(responseData.toString());

      if (response.statusCode >= 400) {
        log(responseData["error"].toString());
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        // final payData = json.decode(response.body)["data"];
        // log(responseData.toString());
        // log(_paymentData.rzpOrderId!);
      } else {
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
