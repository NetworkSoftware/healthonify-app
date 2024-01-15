import 'dart:convert';
import 'dart:developer';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class AssignPackage {
  static Future<void> physioAssignPackage(Map<String, dynamic> data) async {
    String url = "${ApiUrl.url}expert/assignPackage";

    log(json.encode(data));

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      log(responseData.toString());

      if (response.statusCode >= 400) {
        // log(responseData["error"].toString());
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        log(responseData["message"]);
        // final payData = json.decode(response.body)["data"];
        // log(responseData.toString());
        // log(_paymentData.rzpOrderId!);
      } else {
        // log(responseData["error"].toString());
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> wmAssignPackage(Map<String, dynamic> data) async {
    String url = "${ApiUrl.wm}/wm/expert/assignPackage";

    // log(json.encode(data));

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      log(response.body.toString());

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        // log(responseData["error"].toString());
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        log(responseData["message"]);
        // final payData = json.decode(response.body)["data"];
        // log(responseData.toString());
        // log(_paymentData.rzpOrderId!);
      } else {
        // log(responseData["error"].toString());
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }
}
