import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/api_url.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:http/http.dart' as http;

class AssignWmPackage with ChangeNotifier {
  Future<void> assignWmPackage(Map<String, dynamic> data) async {
    String url = '${ApiUrl.wm}wm/expert/assignPackage';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(responseData['message']);
      }
      if (responseData['status'] == 1) {
        log(responseData['message']);
        Fluttertoast.showToast(msg: 'Payment initiated');
      } else {
        log(responseData['error']);
        throw HttpException(responseData["message"]);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
