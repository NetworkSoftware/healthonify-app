import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:http/http.dart' as http;

class SignUpData with ChangeNotifier {
  bool localSession = false;

  Future<void> register(Map<String, String> authData) async {
    String url = "${ApiUrl.url}register";
    var requestData = json.encode({
      "firstName": authData["firstName"],
      "lastName": authData["lastName"],
      "mobileNo": authData["mobileNo"],
      "email": authData["email"],
      "password": authData["password"],
      "roles": authData["roles"]
    });
    log(url);
    log("auth reg data : $authData");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: requestData,
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 204) {
        throw HttpException("Not able to register");
      }
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      final data = json.decode(response.body)["data"];

      SharedPrefManager pref = SharedPrefManager();
      await pref.saveUserId(data[0]["userId"]);

      // print(data[0]["userId"]);

      // print(_loginData.roles);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> otpCheck(Map<String, dynamic> data) async {
    String url = "${ApiUrl.url}verifyOtp";
    var requestData = json.encode(data);
    log(requestData);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: requestData,
      );

      final responseData = json.decode(response.body);
      log(responseData.toString());
      if (response.statusCode == 204) {
        throw HttpException("Entered OTP was wrong");
      }
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      final data = json.decode(response.body)["data"];

      SharedPrefManager pref = SharedPrefManager();
      await pref.saveUserId(data["userId"]);
      await pref.saveRoles(data['roles'][0]);

      // print(data[0]["userId"]);

      // print(_loginData.roles);
      // notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> optResend(String mobileNo) async {
    String url = "${ApiUrl.url}resendOtp";
    var requestData = json.encode({
      "mobileNo": mobileNo,
    });
    log(requestData);
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: requestData,
      );

      log(response.body);

      final responseData = json.decode(response.body);
      if (response.statusCode == 204) {
        throw HttpException("Not able to resend otp");
      }
      if (response.statusCode >= 400) {
        throw HttpException(responseData["message"]);
      }

      // final data = json.decode(response.body)["data"];

      // SharedPrefManager pref = SharedPrefManager();
      // log(data);

      // print(data[0]["userId"]);

      // print(_loginData.roles);
      // notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
