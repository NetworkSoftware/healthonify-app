import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordProvider with ChangeNotifier {
  Future<void> forgotPassword(String mobileNo) async {
    String url = '${ApiUrl.url}forgotPassword';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"mobileNo": mobileNo}),
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        log("forgotPassword error $responseData");
        throw HttpException(responseData["message"]);
      }
      if (responseData["status"] == 1) {
        log(responseData.toString());
      } else {
        throw HttpException(responseData["message"]);
      }
      // final eData = json.decode(response.body)['data'];

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
